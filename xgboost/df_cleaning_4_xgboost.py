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

os.chdir('/Volumes/Bitcasa2/Forestbirds/Lidar/PA_metrics')

# %% Import the data

df = pd.read_pickle('master.pkl')

# %% Cleanup Datset for gradient boost

# Get rid of points where aspect is -9999 (only 110 of them) and elevation is >0 (4 of them)
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
unn = ['Treat_fact','Treatment', 'x', 'y', 'MaxTime', 'MinTime', 'DiffTime', 'NumFirst', 'NumFirstGround', 'NumGround', 'NumPoints', 'geometry', 'RTH_OBJECTID', 'TreatmentD', 
         'YearHarves', 'MinYR', 'HarvYR','YRDiff','SFB_OBJECTID', 'SF_Name', 'WnaType']

# Make Treatment the last column for easier use in xgboost
df = df[[c for c in df if c not in unn] + unn]

# %%
# Change directory
os.chdir('/Volumes/Bitcasa2/Forestbirds/GBoost')

# Save df version
df.to_pickle('df_gboost.pkl')