#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 12 20:55:29 2022

@author: burch
"""
import os
import pandas as pd
import matplotlib.pyplot as plt
from skimage.filters.rank import majority, minimum
from skimage.morphology import disk
import numpy as np
import rasterio
from sklearn.metrics import accuracy_score, classification_report
from sklearn.metrics import ConfusionMatrixDisplay
import geopandas
import pylandstats as pls

os.chdir('/Users/burch/Desktop')

# File paths
fp = '/Volumes/Bitcasa2/Forestbirds/Maj_filt/PA_pred_acc_rand_mostmets_dwmask_1_10_2000_thr_adj_sq10x10.tif'
abcshp = '/Users/burch/Sync/Work4SESYNC/QGIS/DJ_Stuff/ABC_BIRDSCAPES_all_3_6350_modified.shp'
sfbshp = '/Users/burch/Sync/Work4SESYNC/QGIS/RTH/PA_SFB_6350_mask.shp'
rthshp = '/Users/burch/Sync/Work4SESYNC/QGIS/RTH/PA_RTH_6350_mask.shp'
stpshp = '/Users/burch/Sync/Work4SESYNC/QGIS/DCNR_StateParks201703/DCNR_StateParks201703_6350.shp'
sglshp = '/Users/burch/Sync/Work4SESYNC/QGIS/PGC_StateGameland2021/PGC_StateGameland2021_6350.shp'
pagapshp = '/Users/burch/Sync/Work4SESYNC/QGIS/PA_GAP_stewardship/pa_gap_stewardship_1999_6350.shp'

# Import dataset
dataset = rasterio.open(fp)
data = dataset.read(1)
data[data>0] = 1

# %% Run minimum filter
er40 = minimum(data, disk(40)) # radius of 400 meters
er30 = minimum(data, disk(30))  
er20 = minimum(data, disk(20))  
er10 = minimum(data, disk(10)) 

# Import original dataset
dataseto = rasterio.open(fp)
datao = dataseto.read(1)

dater40 = er40*datao
dater30 = er30*datao
dater20 = er20*datao
dater10 = er10*datao


# %% To export majority data tif
with rasterio.open(
    'dater40.tif',
    'w',
    driver='GTiff',
    height=data.shape[0],
    width=data.shape[1],
    count=1,
    dtype=data.dtype,
    crs='epsg:6350',
    transform=dataset.transform,
    nodata=0
) as dst:
    dst.write(dater40, 1)

# %% Prepare data for PyLandStats
# Read shp into geopandas and dissolve
abc = geopandas.read_file(abcshp)
sfb = geopandas.read_file(sfbshp).dissolve()
rth = geopandas.read_file(rthshp).dissolve()
stp = geopandas.read_file(stpshp).dissolve()
sgl = geopandas.read_file(sglshp).dissolve()
pagap = geopandas.read_file(pagapshp).dissolve()

# Merge/Combine multiple shapefiles into one
public_lands = geopandas.pd.concat([sfb,rth,stp,sgl,pagap]).dissolve()
    
# Clip public_lands by ABC
pub_clip = geopandas.clip(public_lands, abc)
pub_clip['Type'] = 'Public'
pub_clip = pub_clip[['Type','geometry']]
 
# Create intersection between abc and pub_clip
union = abc.overlay(pub_clip, how='union')

# Remove a weird tiny row
union = union.iloc[:6,:]

# Separate into private and public
pr = union[union.Type != 'Public']
pu = union[union.Type == 'Public']


# %% PyLandStats Zonal Analysis

mask = pu
ds = "/Users/burch/Desktop/dater40.tif"
ds = fp
 
za = pls.ZonalAnalysis(ds, masks=mask, masks_index_col="Birdscape")

class_metrics_pr = za.compute_class_metrics_df(metrics=["proportion_of_landscape", 'total_area'])   #, 'number_of_patches'
class_metrics_pr

#class_metrics_df.xs('PA Wilds', level=1).sum()


