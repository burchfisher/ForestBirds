#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script to extract data from lidar metric geotiffs and then spatial join with 
PA State Forest Boundraies shapefile - SFB

Created on Tue May 10 16:02:09 2022

@author: burch
"""

# %% Load packages

import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import glob
import geopandas
import rasterio
import seaborn as sns
import fiona
import rasterio.mask

# Access the folder with the lidar metric files 

os.chdir('/Volumes/Bitcasa2/Forestbirds/Lidar/PA_metrics')

# %% Make clipped rasters to extract point locations from the 10m pixels

# For the State Forest with the plus30m RTH clippped out 
with fiona.open("/Users/burch/Sync/Work4SESYNC/QGIS/RTH/SFB_symdiff_RTH_plus30m_clipby_SFB_mask.shp", "r") as shapefile:
    shapes = [feature["geometry"] for feature in shapefile]
    

with rasterio.open("/Volumes/Bitcasa2/Forestbirds/Lidar/PA_metrics/p95.tif") as src:
    out_image, out_transform = rasterio.mask.mask(src, shapes, crop=False)
    out_meta = src.meta
    

out_meta.update({"driver": "GTiff",
                 "height": out_image.shape[1],
                 "width": out_image.shape[2],
                 "transform": out_transform})

with rasterio.open("/Volumes/Bitcasa2/Forestbirds/Lidar/PA_RTH/SFB.tif", "w", **out_meta) as dest:
    dest.write(out_image)


# REMOVE ALL THE VARIABLES FROM ABOVE HERE
del(dest, out_image, out_meta, out_transform, shapefile, shapes, src)
    
# %% Setting up RTH df and getting coordinates

# Glob the file names for the metrics and sort
files = list(glob.glob('*.tif'))
files.sort()

# Remove '.tif' for use as df column names and append to other names
colnms = ['x','y','xcoord','ycoord']
metrics = [row.split('.')[0] for row in files]
colnms = colnms + metrics

# Import dataset
dataset = rasterio.open('/Volumes/Bitcasa2/Forestbirds/Lidar/PA_RTH/SFB.tif')

# Read the data in
data = dataset.read(1)
data[data == -9999] = np.nan

# Create an index of non-NULL values
idx = np.where(data>-9999)

# Create dataframe
df = pd.DataFrame(index=np.arange(len(idx[0])), columns=np.arange(len(colnms)))
df.columns = colnms

# Use the index to fill df with coord info
df['x'] = idx[1]
df['y'] = idx[0]
df['xcoord'],df['ycoord'] = dataset.transform * (df.x, df.y)

del(data, dataset)

# %% For loop to go through all metric TIFs and extract data into df
for x in np.arange(0,len(files)):
    
    dataset = rasterio.open(files[x])
    data = dataset.read(1)
    data[data == -9999] = np.nan
    df.iloc[:,4+x] = data[idx]
    print(files[x])
    del(data, dataset)

del(x)

df.to_pickle('SFB_df')

# %% DECIMATE THE DATASET TO ~2 million points
df = df.loc[::40,:]

# %% Create Geopandas DF

# Convert df into a geopandas DF
gdf = geopandas.GeoDataFrame(df, geometry=geopandas.points_from_xy(df.xcoord, df.ycoord))

# Set CRS
gdf = gdf.set_crs("EPSG:6350")

gdf.to_pickle('SFB_metrics_gdf.pkl')

# Remove extraneous files
del(colnms, df, files, idx, metrics)
# %% IMPORT SFB SHAPEFILE DATA AS GEOPANDAS DF

# Read the data into a GPD DF
path_to_data = '/Users/burch/Sync/Work4SESYNC/QGIS/RTH/PA_SFB_6350.shp'
sfb = geopandas.read_file(path_to_data)
del(path_to_data)

# %% Spatial join sfb data to gdf metric data
master = geopandas.sjoin(gdf, sfb, how="left")

# Drop unnecessary columns
master.drop(columns=['SubType', 'DistrictNu', 'DistrictNa', 'index_right', 'WnaName', 'StParkName', 'SGL_No', 'LandManage', 'Notes', 'Acreage',
'PerimeterF', 'CreatedBy', 'CreatedDat', 'LastEdited', 'LastEdit_1', 'GlobalID', 'Shape_Leng', 'Shape_Area', 'LATITUDE', 'LONGITUDE', 'DESCRIPTIO'], inplace=True)

# Rename OBJECTID
master.rename(columns={"OBJECTID": "SFB_OBJECTID"}, inplace=True)

del(gdf, sfb)

# %% SAVE AS AND READ IN

master.to_pickle('SFB_master.pkl')
