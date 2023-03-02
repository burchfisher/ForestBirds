#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun  1 20:32:20 2022

@author: burch
"""

# %% Load packages

import os
import pandas as pd
import numpy as np

# Access the folder with the lidar metric files 

os.chdir('/Volumes/Bitcasa2/Forestbirds/GBoost')

# %% Import the data

df = pd.read_pickle('master.pkl')

# %% Cleanup Datset for gradient boost

# Get rid of points where aspect is -9999 (only 110 of them) and elevation is <0 (4 of them)
df = df[df.aspect >= 0]
df = df[df.elev > 0]

# Need to convert NaNs to -100 in the YRDiff col
df.YRDiff[df.YRDiff.isna()==True] = -100

# Classify Untreated Rows
df.Treatment[df.Treatment.isna()==True] = 'Untreated'

# Remove any YRDiff values == 0 because they are ambiguous with the lidar data
df = df[df.YRDiff != 0]

# Fatcorize the Treatment column for using in XGBoost
df['Treat_fact'], uniques = pd.factorize(df.Treatment)

# Move unnecessary columns to the end of the DF
unn = ['x', 'y', 'xcoord', 'ycoord', 'Below1m', 'Below2m', 'Below5m','FirstBelow1m', 'FirstBelow2m', 'FirstBelow5m','MOCH','Perc_5m_to_2m', 'Perc_5m_to_1m','TopRug30m_MOCH','TopRug50m_MOCH',
       'DiffTime','MaxTime', 'MinTime', 'NumFirst', 'NumFirstGround', 'NumGround','NumPoints', 'p10', 'p25', 'p5','p50', 'geometry', 'RTH_OBJECTID',
       'Treatment', 'TreatmentD', 'YearHarves', 'MinYR', 'HarvYR', 'YRDiff','SFB_OBJECTID', 'SF_Name', 'WnaType', 'dw']

# Make Treatment the last column for easier use in xgboost
df = df[[c for c in df if c not in unn] + unn]

# Only use the 'Trees' (1) and 'Shrub and Scrub'(5) from the Dynamic World composite
df = df[(df.dw == 1) | (df.dw == 5)]

# Remove any values from the voxels that are equal to -9999
df = df[df.V50 != -9999.0]

# %% Removing data from the NW area training and test data where values are wonky
df = df[~df.SFB_OBJECTID.isin([2,88,831,832,833,834,951])]

df = df[~df.RTH_OBJECTID.isin([8859,9485,9486,21855,21857])]

# %%
# Change directory
os.chdir('/Volumes/Bitcasa2/Forestbirds/GBoost')

# Save df version
df.to_pickle('df_gboost.pkl')