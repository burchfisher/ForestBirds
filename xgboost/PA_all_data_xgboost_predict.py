#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun  8 19:55:27 2022

@author: burch
"""
import os
import pandas as pd
import numpy as np
import glob
import geopandas
import rasterio
import fiona

# multiclass classification
from xgboost import XGBClassifier
from xgboost import plot_importance
from sklearn.model_selection import train_test_split, GridSearchCV, StratifiedKFold
from sklearn.metrics import accuracy_score, classification_report
from sklearn.inspection import permutation_importance
from sklearn.metrics import ConfusionMatrixDisplay

# Access the folder with the lidar metric files 

os.chdir('/Volumes/Bitcasa2/Forestbirds/Lidar/PA_metrics')


# %% Setting up DF with the x and y data

# Glob the file names for the metrics and sort
# files = list(glob.glob('*.tif'))
# files.sort()

# Getting in the same order as xgboost model
# files = [e for e in files if e not in ('FirstBelow1m.tif','FirstBelow2m.tif','FirstBelow5m.tif','Below1m.tif','Below2m.tif','Below5m.tif','Perc_2m_to_1m.tif','Perc_5m_to_1m.tif',
#                                        'Perc_5m_to_2m.tif', 'p10.tif', 'p25.tif', 'p5.tif', 'p50.tif','MOCH.tif', 'p75.tif', 'TopRug30m_MOCH.tif', 'TopRug50m_MOCH.tif','DiffTime.tif',
#                                        'MaxTime.tif','MinTime.tif','NumFirst.tif','NumFirstGround.tif','NumGround.tif','NumPoints.tif','elev.tif','slope.tif','aspect.tif')]+['elev.tif','slope.tif']

metrics = ['IQR', 'Perc_2m_to_1m', 'Perc_First_2m_to_1m', 'Perc_First_5m_to_1m',
       'Perc_First_5m_to_2m', 'TopRug', 'TopRug30m_p95', 'TopRug30m_p99',
       'TopRug50m_p95', 'TopRug50m_p99', 'p75', 'p90', 'p95', 'p99', 'elev',
       'slope', 'aspect', 'V2', 'V4', 'V6', 'V8', 'V10', 'V12', 'V14', 'V16',
       'V18', 'V20', 'V22', 'V24', 'V26', 'V28', 'V30', 'V32', 'V34', 'V36',
       'V38', 'V40', 'V42', 'V44', 'V46', 'V48', 'V50']

# Remove '.tif' for use as df column names and append to other names
colnms = ['x','y']
files = [row+'.tif' for row in metrics]
# metrics = [row.split('.')[0] for row in files]
colnms = colnms + metrics
del(metrics)

# XGBOOST trained model columns and order
# p = ['xcoord', 'ycoord', 'Below1m', 'Below2m', 'Below5m', 'FirstBelow1m',
#        'FirstBelow2m', 'FirstBelow5m', 'IQR', 'MOCH', 'Perc_2m_to_1m',
#        'Perc_5m_to_1m', 'Perc_5m_to_2m', 'Perc_First_2m_to_1m',
#        'Perc_First_5m_to_1m', 'Perc_First_5m_to_2m', 'TopRug',
#        'TopRug30m_MOCH', 'TopRug30m_p95', 'TopRug30m_p99', 'TopRug50m_MOCH',
#        'TopRug50m_p95', 'TopRug50m_p99', 'p10', 'p25', 'p5', 'p50', 'p75',
#        'p90', 'p95', 'p99', 'elev', 'slope', 'aspect']

# Import dataset
dataset = rasterio.open('V2.tif')

# Read the data in
data = dataset.read(1)

# Open DW raster to make a mask
datasetdw = rasterio.open('/Volumes/Bitcasa2/Forestbirds/DynamicWorldV1/2020_dw_composite_raw_6350_resampled.tif')
datadw = datasetdw.read(1)

# Use datadw indices to mask data 
data[np.isin(datadw, [0,2,3,4,6,7,8])==True] = -9999

# Create an index of non-NULL values
idx = np.where(data>=0)
del(data, dataset, datadw, datasetdw)

# Create dataframe
# df = pd.DataFrame(index=np.arange(len(idx[0])), columns=np.arange(2))
# df.columns = colnms[:2]

# # Use the index to fill df with coord info
# df['x'] = idx[1]
# df['y'] = idx[0]

# %%
# Save file
# df.to_pickle('df_pred.pkl')

# # Read in file
# df = pd.read_pickle('df_pred.pkl')

# %% Load in xgboost model
os.chdir('/Volumes/Bitcasa2/Forestbirds/GBoost')

model = XGBClassifier()
model.load_model("XGB_model_sklearn_mostmets_1_10_2000.json")

os.chdir('/Volumes/Bitcasa2/Forestbirds/Lidar/PA_metrics')

idx = np.load('idx.npy')
# %% For loop to go through all metric TIFs and extract data into df

# Size of subset
chunk = 40000000
rng = np.arange(744000000,len(idx[0]), chunk)
rng = np.append(rng, len(idx[0]))
num = len(rng)-1

# Initialize array of predicitons (set all to -1)
# predictions = np.ones(len(idx[0])).astype(int)*-9999
# pred_proba = np.zeros((len(idx[0]),5))

# predictions = np.load('predictions_mostmets.npy')
# pred_proba = np.load('probabilities_mostmets_1_10_2000.npy')

# Outer For loop (goes through df in chunks)
for z in np.arange(0,num):
    
    start = rng[z]
    stop = rng[z+1]
    
    # Get subset of df
    xgb = np.full((stop-start,len(files)),-9999.0)
    
    # Inner For Loop (loads values into the columns from the tifs)
    for x in np.arange(0,len(files)):
        dataset = rasterio.open(files[x])
        data = dataset.read(1)
        xgb[:,x] = data[idx[0][start:stop], idx[1][start:stop]]
        print(files[x])
        del(data, dataset)
    
    # Find indices where there are no negative numbers in xgb
    idn = np.where(np.any(xgb < 0, axis=1) == False)[0]
    
    # Run the xgboost model on the xgb dataframe
    # pred = model.predict(xgb.loc[idn,colnms[2]:colnms[-1]])
    proba = model.predict_proba(xgb[idn,:])
    del(xgb)
    
    # predictions = np.load('predictions_mostmets.npy')
    pred_proba = np.load('probabilities_mostmets_1_10_2000.npy')

    # Add the predicitons and probabilities into their appropriate indices in predictions array
    # predictions[idn] = pred
    pred_proba[idn+start,:] = proba
    del(proba,idn)
    
    # Save predicitons in case it craps out I don't have to start at 0 again
    #np.save('predictions_mostmets_1_10_2000', predictions)
    np.save('probabilities_mostmets_1_10_2000', pred_proba)
    del(pred_proba)
    
    # Print index value just finished through
    print(stop)

    del(x, start, stop)


# %% Calculate predictions from highest probability
# find where there are all 0s in the probabilities
idz = np.where(np.sum(pred_proba<=0, axis=1)>4)[0]

# take the column with the maximum probability
pred = np.argmax(pred_proba, axis=1) 

# convert those columns with -9999 to -9999 values again
pred[idz] = -9999 

# %% Calculate predictions from highest probability above the threshold values

os.chdir('/Volumes/Bitcasa2/Forestbirds/GBoost/cats5')

# load in probabilities dataset
probs = np.load('probabilities_mostmets_1_10_2000.npy')

# thresholds calculated from the ROC plot data
thr = [0.39,0.30,0.03,0.1,0.01]

# Turn points lower than their threshold to 0
tf = probs >= thr
probs_tf = probs * tf

# find where there are all 0s in the probabilities
idz = np.where(np.sum(probs_tf<=0, axis=1)>4)[0]

# take the column with the maximum probability
pred = np.argmax(probs_tf, axis=1) 

# convert those columns with -9999 to -9999 values again
pred[idz] = -9999 

# %% Convert into a raster

# Open raster to get attributes and data 
dataset = rasterio.open('/Volumes/Bitcasa2/Forestbirds/Lidar/PA_metrics/V50.tif')
data = dataset.read(1)

# Set all the values to -9999
data[data>=-9999] = -9999

# Set data values to the prediction values
data[idx] = pred

with rasterio.open(
    'PA_pred_acc_rand_mostmets_dwmask_1_10_2000_thr_adj.tif',
    'w',
    driver='GTiff',
    height=data.shape[0],
    width=data.shape[1],
    count=1,
    dtype=data.dtype,
    crs='epsg:6350',
    transform=dataset.transform,
    nodata=-9999.0
) as dst:
    dst.write(data, 1)







