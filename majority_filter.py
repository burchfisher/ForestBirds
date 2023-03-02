#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script to run majority filters on and test xgboost prediction  

Created on Mon Jul 25 22:15:40 2022

@author: burch
"""
import os
import pandas as pd
import matplotlib.pyplot as plt
from skimage.filters.rank import majority
from skimage.morphology import square, disk, erosion
import numpy as np
import rasterio
from sklearn.metrics import accuracy_score, classification_report
from sklearn.metrics import ConfusionMatrixDisplay

os.chdir('/Volumes/Bitcasa2/Forestbirds/Maj_filt')

# Import dataset
dataset = rasterio.open('/Volumes/Bitcasa2/Forestbirds/GBoost/cats5/PA_pred_acc_rand_mostmets_dwmask_1_10_2000_thr_adj.tif')
data = dataset.read(1)
data[data==-9999] = 5
data = np.ubyte(data)

# Create mask
data = data + 1
data[data==6] = 0
idx = np.where(data==0)

# %% Run filter
maj20 = majority(data, square(20), mask=data)
maj10 = majority(data, square(10), mask=data)
maj5 = majority(data, square(5), mask=data)

# Due to bleed on the margins need to reset background pixels to 0
maj20[idx] = 0
maj10[idx] = 0
maj5[idx] = 0

# To export majority data tif
with rasterio.open(
    'PA_pred_acc_rand_mostmets_dwmask_1_10_2000_thr_adj_sq20x20.tif',
    'w',
    driver='GTiff',
    height=maj20.shape[0],
    width=maj20.shape[1],
    count=1,
    dtype=maj20.dtype,
    crs='epsg:6350',
    transform=dataset.transform,
    nodata=0
) as dst:
    dst.write(maj20, 1)


# %% Prep df Categories for testing accuracy

os.chdir('/Volumes/Bitcasa2/Forestbirds/Maj_filt')

df = pd.read_pickle('dftest.pkl')

labels=['Untreated','Removal 1-9 yrs','Removal 10-18 yrs','Shelterwood 1-9 yrs', 'Shelterwood 10-18 yrs']

# %% Add Majority data to df

df['maj5'] = maj5[df.y,df.x] - 1
df['maj10'] = maj10[df.y,df.x] - 1
df['maj20'] = maj20[df.y,df.x] - 1

df['maj5_thr_adj'] = maj5[df.y,df.x] - 1
df['maj10_thr_adj'] = maj10[df.y,df.x] - 1
df['maj20_thr_adj'] = maj20[df.y,df.x] - 1

df.preds = data[df.y,df.x] - 1

# Remove rows where background was sampled (e.g. 0 --> 255 when 1 was subtracted)
df = df[df.maj5!=255]

# %% Evaluate Accuracy of Majority Filters

# evaluate predictions
accuracy = accuracy_score(df.Treat_fact, df.maj10_thr_adj)
print("Accuracy: %.2f%%" % (accuracy * 100.0))

# confusion matrix and report
a = ConfusionMatrixDisplay.from_predictions(df.Treat_fact, df.maj10_thr_adj, normalize=None, display_labels=labels)
plt.title('Majority Accuracy 10x10 pixels')
plt.xticks(rotation = 45)
plt.yticks(rotation = 45)
plt.tight_layout(h_pad=0)
plt.show()

print(classification_report(df.Treat_fact, df.maj10_thr_adj, target_names=labels))

# %%
import seaborn as sns 

fig, axs = plt.subplots(5, 1, figsize=(5,40), sharex=True)
trt = np.arange(0,5)
a = 1
c = False

for i in trt:
    idy = np.where(df.preds == i)[0]
    idm = np.where(df.maj10 == i)[0]
    idt = np.where(df.Treat_fact == i)[0]
    sns.histplot(df.iloc[idt,8+i], color='black', fill=False, element='poly', stat='proportion', cumulative=c, alpha=1, ax=axs[i], label='True')  
    sns.histplot(df.iloc[idy,8+i], color='blue', fill=True, element='poly', stat='proportion', cumulative=c, alpha=0.25, ax=axs[i], label='Predicted')
    sns.histplot(df.iloc[idm,8+i], color='red', fill=True, element='poly', stat='proportion', cumulative=c, alpha=0.25, ax=axs[i], label='Majority10m')      
    axs[i].set_ylim([0.001,a])
    axs[i].set_yscale('log')
    axs[0].set_title('Histograms of Class Probabilities')
    plt.xlabel('Prediction Probability')
    axs[0].legend()
plt.tight_layout()


# %% Table for Threshold Analysis
df = pd.read_pickle('dftest.pkl')
probs= df.loc[:,'prob_0':'prob_4']
test = probs >= [0.39,0.31,0.10,0.20,0.05]
test = test * [1,10,100,1000,10000]
tot = test.sum(axis=1)
df2 = tot.value_counts().sort_index()*100/len(tot)

df3 = pd.DataFrame(df2, columns=['mpct'])
df3['p0'] = 0
df3['p1'] = 0
df3['p2'] = 0
df3['p3'] = 0
df3['p4'] = 0

for row in df3.index:
    vals = df.preds[row == tot]
    df3.loc[row, 'p0'] = 100*sum(vals==0)/len(vals)
    df3.loc[row,'p1'] = 100*sum(vals==1)/len(vals)
    df3.loc[row,'p2'] = 100*sum(vals==2)/len(vals)
    df3.loc[row,'p3'] = 100*sum(vals==3)/len(vals)
    df3.loc[row,'p4'] = 100*sum(vals==4)/len(vals)

    
    



