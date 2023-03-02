#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script to merge RTH and SFB datasets following creation with RTH_prep.py and SFB_prep.py and produce plots 

Created on Mon Apr 18 20:31:23 2022

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

# %% IMPORT DATASETS
rth = pd.read_pickle('RTH_master.pkl')
sfb = pd.read_pickle('SFB_master.pkl')

# %% COMBINE DATASETS
master = pd.concat([rth, sfb], ignore_index=True)
del(rth,sfb) 
# %% Extract Elevation, Slope, Aspect, and 2020 Dynamic World Composite data
os.chdir('/Users/burch/Sync/Work4SESYNC/QGIS/DEM/')

# Import the elevation datasets
srcD = rasterio.open('dem_30m_epsg6350.tif')
srcS = rasterio.open('slope_30m_epsg6350.tif')
srcA = rasterio.open('aspect_30m_epsg6350.tif')
dw = rasterio.open('/Volumes/Bitcasa2/Forestbirds/Lidar/PA_metrics/2020_dw_composite_raw_6350_resampled.tif')

# Get coordinates of points in correct format for rasterio
coord_list = [(x,y) for x,y in zip(master['geometry'].x , master['geometry'].y)]

# Sample the elevation datasets and assign to new columns
master['elev'] = [x for x in srcD.sample(coord_list)]
master['slope'] = [x for x in srcS.sample(coord_list)]
master['aspect'] = [x for x in srcA.sample(coord_list)]
master['dw'] = [x for x in dw.sample(coord_list)]

# Make elevation derivatives floats
master.loc[:,'elev':'aspect'] = master.loc[:,'elev':'aspect'].astype('float')
master.loc[:,'dw'] = master.loc[:,'dw'].astype('int')

# %% Get all of the Voxel data into the df

os.chdir('/Volumes/Bitcasa2/Forestbirds/Lidar/Voxels/PA_2m_voxels')

files = list(glob.glob('*.tif'))
files = ['V2.tif','V4.tif','V6.tif','V8.tif','V10.tif','V12.tif','V14.tif','V16.tif','V18.tif','V20.tif','V22.tif','V24.tif','V26.tif','V28.tif','V30.tif',
         'V32.tif','V34.tif','V36.tif','V38.tif','V40.tif','V42.tif','V44.tif','V46.tif','V48.tif','V50.tif']

# Remove '.tif' for use as df column names
metrics = [row.split('.')[0] for row in files]

# Get coordinates of points in correct format for rasterio
coord_list = [(x,y) for x,y in zip(master['geometry'].x , master['geometry'].y)]

# Extract voxel data into master
for num in np.arange(0,len(files)):
    print(files[num])
    src = rasterio.open(files[num])
    master[metrics[num]] = [x for x in src.sample(coord_list)]
    master[metrics[num]] = master[metrics[num]].astype('float') 
    
# %% Save
os.chdir('/Volumes/Bitcasa2/Forestbirds/Lidar/PA_metrics')

master.to_pickle('master.pkl')

# %% VIOLINPLOTS
perc = ['Below1m', 'Below2m', 'Below5m',
       'FirstBelow1m', 'FirstBelow2m', 'FirstBelow5m',
       'Perc_2m_to_1m', 'Perc_5m_to_1m', 'Perc_5m_to_2m',
       'Perc_First_2m_to_1m', 'Perc_First_5m_to_1m', 'Perc_First_5m_to_2m']


met = ['MOCH', 'IQR', 'TopRug', 'TopRug30m_MOCH', 'TopRug30m_p95', 'TopRug30m_p99', 
       'TopRug50m_MOCH', 'TopRug50m_p95', 'TopRug50m_p99', 'p5', 'p10', 'p25',
       'p50', 'p75', 'p90', 'p95', 'p99']

pts = ['NumPoints', 'NumFirst', 'NumGround', 'NumFirstGround']

# Subset DF for plotting
mast = master.copy()
mast = mast[(mast.YRDiff > -50) & (mast.YRDiff < 0)]
mast = mast[(mast.HarvYR == 2050)]

# Melt to long form for plotting
p = mast.melt(id_vars=['YRDiff'], value_vars=perc, var_name='metric', value_name='value')
m = mast.melt(id_vars=['YRDiff'], value_vars=met, var_name='metric', value_name='value')
s = mast.melt(id_vars=['YRDiff'], value_vars=pts, var_name='metric', value_name='value')


# Percentile Metric Plot
plt.figure(figsize = (15,8))
sns.violinplot(x=p.metric, y=p.value, hue=p.Treatment, scale='width', linewidth=1, cut=0, split=True, palette='husl', inner="quartile",  hue_order=['Removal','Shelterwood'])
plt.xticks(rotation=45)
plt.xlabel('')
plt.ylabel('percent')
plt.title('Percentile Lidar Metrics')
plt.tight_layout(h_pad=0)


# Measured Metric Plot
plt.figure(figsize = (15,8))
sns.violinplot(x=m.metric, y=m.value, hue=m.Treatment, scale='width', linewidth=1, cut=0, split=True, palette='husl', inner="quartile", order=met, hue_order=['Removal','Shelterwood'])
plt.xticks(rotation=45)
plt.xlabel('')
plt.ylabel('meters')
plt.title('Measured Lidar Metrics')
plt.tight_layout(h_pad=0)


# Points Metric Plot
plt.figure(figsize = (15,8))
sns.violinplot(x=s.metric, y=s.value, hue=s.Treatment, scale='width', linewidth=1, cut=0, split=True, palette='husl', inner="quartile", order=pts,  hue_order=['Removal','Shelterwood'])
plt.xticks(rotation=45)
plt.xlabel('')
plt.ylabel('points/100 m^2')
plt.title('Lidar Points Metrics')
plt.tight_layout(h_pad=0)
plt.ylim(0,4000)


# %% KDE plots 
mast = master[master.YRDiff.isin([1,2,3,4,5,np.nan])]

mast = master[master.HarvYR.isin([2050,np.nan])]

met = ['Below1m', 'Below2m', 'Below5m',
       'FirstBelow1m', 'FirstBelow2m', 'FirstBelow5m',
       'Perc_2m_to_1m', 'Perc_5m_to_1m', 'Perc_5m_to_2m',
       'Perc_First_2m_to_1m', 'Perc_First_5m_to_1m', 'Perc_First_5m_to_2m']

fig, axes = plt.subplots(ncols=3, nrows=4, figsize=(18,24))

for i, ax in zip(range(12), axes.flat):
    sns.kdeplot(data=mast, x=met[i], hue="Treatment", fill=True, common_norm=False, palette="husl", cut=0, alpha=.5, linewidth=0, ax=ax)
fig.suptitle('Untreated and Not Yet Harvested Comparison', y=0.92, weight='bold')
plt.show()    


# %% For Plotting Time Series Groups of RTH
met = ['IQR', 'TopRug', 'TopRug30m_p95', 'TopRug30m_p99', 
       'TopRug50m_p95', 'TopRug50m_p99', 'p75', 'p95', 'p99']

met = ['p75','p95','IQR','TopRug']

met=['V2']

p = mast.melt(id_vars=['YRDiff', 'Treatment'], value_vars=met, var_name='metric', value_name='value')

p['group'] = np.nan
p.group[(p.YRDiff < 6) & (p.YRDiff > 0)] = '1-5 years'
p.group[(p.YRDiff < 11) & (p.YRDiff > 5)] = '6-10 years'
p.group[(p.YRDiff < 16) & (p.YRDiff > 10)] = '11-15 years'
p.group[(p.YRDiff < 21) & (p.YRDiff > 15)] = '16-20 years'
p.group[(p.YRDiff < 26) & (p.YRDiff > 20)] = '21-25 years'

    
g = sns.catplot(x="group", y="value", hue="Treatment", col="metric", data=p, kind="violin", split=True, scale='width', palette='husl', cut=0, inner='quartile', order=['1-5 years', '6-10 years','11-15 years', '16-20 years', '21-25 years'], legend=False)

g.set_xticklabels(rotation=45)
plt.tight_layout(h_pad=0)
plt.legend(loc='upper right')

g.savefig('V2.pdf',dpi=300)

