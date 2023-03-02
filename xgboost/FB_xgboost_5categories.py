#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script to prepare, test, and run xgboost on the Recent Harvest Treatment dataset using 5 data categories 

Created on Wed Jun  1 20:30:34 2022

@author: burch
"""

# %% Load packages

import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import geopandas
import rasterio

# multiclass classification
from xgboost import XGBClassifier
from xgboost import plot_importance
from sklearn.model_selection import train_test_split, GridSearchCV, StratifiedKFold
from sklearn.metrics import accuracy_score, classification_report
from sklearn.inspection import permutation_importance
from sklearn.metrics import ConfusionMatrixDisplay
import shap

# %% Prep df Categories

os.chdir('/Volumes/Bitcasa2/Forestbirds/GBoost')

# load data
df = pd.read_pickle('df_gboost.pkl')

# Remove data where YRDiff is between -100 and 0
df = df[(df.YRDiff == -100) | (df.YRDiff > 0)]

# Remove data where YRDiff is >19
df = df[df.YRDiff < 19]

# Create 5 Categories
df.Treat_fact[df.Treatment == 'Untreated'] = 0
df.Treat_fact[(df.YRDiff < 10) & (df.Treatment == 'Removal')] = 1
df.Treat_fact[(df.YRDiff >9) & (df.Treatment == 'Removal')] = 2
df.Treat_fact[(df.YRDiff < 10) & (df.Treatment == 'Shelterwood')] = 3
df.Treat_fact[(df.YRDiff >9) & (df.Treatment == 'Shelterwood')] = 4

labels=['Untreated','Removal 1-9 yrs','Removal 10-18 yrs','Shelterwood 1-9 yrs', 'Shelterwood 10-18 yrs']

# %% IF USING AN EQUAL NUMBER FROM EACH CATEGORY TO TEST AND TRAIN
# Sample an even number of each category for xgboost and creating a confusion matrix
def equal_treat(df):
    cats = df.Treat_fact.unique()
    n = 230000    #df.Treat_fact.value_counts().min()
    xgb = pd.DataFrame()
    
    for val in cats:
        d = df[df.Treat_fact == val].sample(n=n, random_state=1)
        if xgb.empty:
            xgb = d
        else: 
            xgb = pd.concat([xgb,d], ignore_index=False)
        
    return xgb
    
xgb = equal_treat(df)

# Test Train Split the data
X_train, X_test, y_train, y_test = train_test_split(xgb.loc[:,'IQR':'V50'], xgb.loc[:,'Treat_fact'],
    test_size=0.3, random_state=7)

# %% If not using equal number start here
# split data into X and y

X = df.loc[:,'IQR':'V50']
y = df.Treat_fact

# Test Train Split the data
X_train, X_test, y_train, y_test = train_test_split(X, y,
    test_size=0.3, random_state=7)

# Split withheld data for predicting on after establishing the model
# xgb2 = df[~df.index.isin(xgb.index)]
# X2 = xgb2.loc[:,'IQR':'V50']
# y2 = xgb2.Treat_fact

# %% IF USING A CHECKERBOARD METHOD TO TEST AND TRAIN

# Bring in the PA grid shapefile
path_to_data = '/Users/burch/Sync/Work4SESYNC/QGIS/Checkerboard/Grid_5km_PA_extent.shp'
chb = geopandas.read_file(path_to_data)
del(path_to_data)

# Do a spatial join with the df and checkerboard
xgb = df.sjoin(chb, how="left")

# split data into X and y
X_train = xgb.loc[(xgb.num == 1),'IQR':'V50']
y_train = xgb.loc[(xgb.num == 1), 'Treat_fact']
X_test = xgb.loc[(xgb.num == 0),'IQR':'V50']
y_test = xgb.loc[(xgb.num == 0), 'Treat_fact']


# %% XGBOOST

# fit model on training data
model = XGBClassifier(max_depth=10, n_estimators=2000, learning_rate=1, base_score=0.5, 
              booster='gbtree', colsample_bylevel=1, colsample_bynode=1, colsample_bytree=1, 
              enable_categorical=False, gamma=0, gpu_id=-1, importance_type=None, 
              interaction_constraints='', max_delta_step=0, min_child_weight=1, monotone_constraints='()', 
              num_parallel_tree=1, objective='multi:softprob', predictor='auto',
              random_state=0, reg_alpha=0, reg_lambda=1, scale_pos_weight=None,
              subsample=1, tree_method='exact', use_label_encoder=False,
              validate_parameters=1, verbosity=None)

model.fit(X_train, y_train)
print(model)

# make predictions for test data
predictions = model.predict(X_test)
pred_proba = model.predict_proba(X_test)

# evaluate predictions
accuracy = accuracy_score(y_test, predictions)
print("Accuracy: %.2f%%" % (accuracy * 100.0))

# confusion matrix and report
a =ConfusionMatrixDisplay.from_predictions(y_test, predictions, normalize=None, display_labels=labels)
plt.title('XGBoost Voxels Plus Other Metrics')
plt.xticks(rotation = 45)
plt.yticks(rotation = 45)
plt.tight_layout(h_pad=0)
plt.show()

print(classification_report(y_test, predictions, target_names=labels))

sorted_idx = model.feature_importances_.argsort()
plt.barh(df.columns[sorted_idx], model.feature_importances_[sorted_idx])
plt.xlabel("Xgboost Feature Importance")

perm_importance = permutation_importance(model, X_train, y_train)

sorted_idx = perm_importance.importances_mean.argsort()
plt.barh(df.columns[sorted_idx], perm_importance.importances_mean[sorted_idx])
plt.xlabel("Permutation Importance")


explainer = shap.TreeExplainer(model)
shap_values = explainer.shap_values(X_train)

shap.summary_plot(shap_values, X_train, plot_type="bar", max_display=10)

shap.summary_plot(shap_values, X_train)

#%% 5 panel plot of each class shap values


fig = plt.figure(figsize=(20,30))

ax0 = fig.add_subplot(321)
ax0.title.set_text('Untreated')
shap.summary_plot(shap_values[0], X_train, plot_type="bar", max_display=10, show=False)
ax0.set_xlim([0,2.5])
plt.subplots_adjust(wspace=1)

ax1 = fig.add_subplot(322)
ax1.title.set_text('Removal 1-9 years')
shap.summary_plot(shap_values[1], X_train, plot_type="bar", max_display=10, show=False)
ax1.set_xlim([0,2.5])
plt.subplots_adjust(wspace=1)

ax2 = fig.add_subplot(323)
ax2.title.set_text('Removal 10-18 years')
shap.summary_plot(shap_values[2], X_train, plot_type="bar", max_display=10, show=False)
ax2.set_xlim([0,2.5])
plt.subplots_adjust(wspace=1)

ax3 = fig.add_subplot(324)
ax3.title.set_text('Shelterwood 10-18 years')
shap.summary_plot(shap_values[3], X_train, plot_type="bar", max_display=10, show=False)
ax3.set_xlim([0,2.5])
plt.subplots_adjust(wspace=1)

ax4 = fig.add_subplot(325)
ax4.title.set_text('Shelterwood 10-18 years')
shap.summary_plot(shap_values[4], X_train, plot_type="bar", max_display=10, show=False)
ax4.set_xlim([0,2.5])
plt.subplots_adjust(wspace=1)

# plt.tight_layout(pad=3) # You can also use plt.tight_layout() instead of using plt.subplots_adjust() to add space between plots
plt.show()
    

# %% Merge data with DF and make a geotiff 

predictions = model.predict(X)

df['pred'] = predictions
df['predTF'] = df.pred == df.Treat_fact
df.predTF = df.predTF.astype(int)

# Convert into a raster
# Open raster to get attributes and data 
dataset = rasterio.open('/Volumes/Bitcasa2/Forestbirds/Lidar/PA_metrics/p99.tif')
data = dataset.read(1)

# Set all the values to -9999
data[data>=-9999] = -9999

# Set data values to the prediction values
data[df.y, df.x] = df.Treat_fact

with rasterio.open(
    'Treat_fact.tif',
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


# %% save model in JSON format
model.save_model("XGB_model_sklearn_mostmets.json")

# to load model
model = XGBClassifier()
model.load_model("XGB_model_sklearn_mostmets_1_10_2000.json")

# %% make predictions for data withheld form the test-train-split
predictions2 = model.predict(X2)

# evaluate predictions
accuracy2 = accuracy_score(y2, predictions2)
print("Accuracy: %.2f%%" % (accuracy2 * 100.0))

print(classification_report(y2, predictions2, target_names=labels))

# confusion matrix and report
ConfusionMatrixDisplay.from_predictions(y2, predictions2, normalize=None, display_labels=labels)
plt.title('XGBoost Checkerboard Train #0')
plt.xticks(rotation = 45)
plt.yticks(rotation = 45)
plt.tight_layout(h_pad=0)
plt.show()


# %% GridSearch to tune hyperparameters

# Grid Search
# eta = []
# maxd = []
# trees = []
# acc = []
# best_acc = 0

for max_depth in [10]:
    for n_estimators in [2400]:
        for learning_rate in [1]:
            print(max_depth,n_estimators,learning_rate)
            # for each combination of parameters, train an SVC
            model = XGBClassifier(base_score=0.5, booster='gbtree', colsample_bylevel=1,
                          colsample_bynode=1, colsample_bytree=1, enable_categorical=False,
                          gamma=0, gpu_id=-1, importance_type=None,
                          interaction_constraints='', learning_rate=learning_rate,
                          max_delta_step=0, max_depth=max_depth, min_child_weight=1,
                          monotone_constraints='()', n_estimators=n_estimators,
                          num_parallel_tree=1, objective='multi:softprob', predictor='auto',
                          random_state=0, reg_alpha=0, reg_lambda=1, scale_pos_weight=None,
                          subsample=1, tree_method='exact', use_label_encoder=False,
                          validate_parameters=1, verbosity=None)
            model.fit(X_train, y_train)
            model.save_model("XGB_model_sklearn_mostmets_1_10_2400.json")

            # make predictions for test data
            predictions = model.predict(X_test)
            accuracy = accuracy_score(y_test, predictions)
            
            # store results
            eta.append(learning_rate)
            maxd.append(max_depth)
            trees.append(n_estimators)
            acc.append(accuracy)
    
            # if we got a better score, store the score and parameters
            if accuracy > best_acc:
                best_acc = accuracy
                best_parameters = {'max_depth': max_depth, 'n_estimators': n_estimators, 'learning_rate': learning_rate}

print("Best score: {:.2f}".format(best_acc))
print("Best parameters: {}".format(best_parameters))

GS2 = pd.DataFrame({'eta':eta,'maxd':maxd,'trees':trees,'acc':acc})
GS2.to_pickle('GS2.pkl')

# %% ROC plots 

import matplotlib.pylab as plt
from sklearn import metrics
from matplotlib import pyplot
from statistics import mean
from sklearn.preprocessing import label_binarize
from itertools import cycle
from sklearn.metrics import roc_curve, auc
from scipy.spatial import distance

def plot_roc_curve(y_test, y_pred):
    
    n_classes = len(np.unique(y_test))
    y_test = label_binarize(y_test, classes=np.arange(n_classes))
    #y_pred = label_binarize(y_pred, classes=np.arange(n_classes))

  # Compute ROC curve and ROC area for each class
    fpr = dict()
    tpr = dict()
    thr = dict()
    roc_auc = dict()
    for i in range(n_classes):
        fpr[i], tpr[i], thr[i] = metrics.roc_curve(y_test[:, i], y_pred[:, i])
        roc_auc[i] = auc(fpr[i], tpr[i])
  
    
  # Find the optimal threshold for each class based on euclidean distance to point [0,1]
    opt = np.ones((5,3))
    d = np.array([[0,1],[1,0]]) # needs to be more than one point for the cdist calc below
    for i in range(n_classes):
        dist = distance.cdist(d,np.array([fpr[i],tpr[i]]).T,'euclidean')[0]
        idx = np.where(dist == dist.min())
        opt[i,0] = fpr[i][idx]
        opt[i,1] = tpr[i][idx]
        opt[i,2] = thr[i][idx]
    
  # Find the optimal threshold for each class based on point where tangent is closest to 1
    opt_t = np.ones((5,4))
    p = 1000    # Make an even number

    for i in range(n_classes):
        ft = pd.DataFrame({'fpr': fpr[i], 'tpr': tpr[i]})
        ft = ft.diff(periods=p)
        ft['slope'] = ft.tpr/ft.fpr
    

        opt_t[i,0] = np.mean(thr[i][ft.slope[(ft.slope >0.99) & (ft.slope <1.01)].index - int(p/2)])
        opt_t[i,1] = np.std(thr[i][ft.slope[(ft.slope >0.99) & (ft.slope <1.01)].index - int(p/2)])
        opt_t[i,2] = fpr[i][np.argsort(abs(thr[i]-opt_t[i,0]))[0]]
        opt_t[i,3] = tpr[i][np.argsort(abs(thr[i]-opt_t[i,0]))[0]]
  
  
    
  b = pd.DataFrame({'Untreated': [0.44,0.42,0.39,0.39,0.39,0.37,0.39], 'Removal 1-9': [0.25,0.30,0.35,0.31,0.31,0.34,0.31], 'Removal 10-18': [0.08,0.09,0.09,0.1,0.1,0.11,0.1], 
                'Shelterwood 1-9': [0.25,0.19,0.17,0.21,0.19,0.21,0.20],'Shelterwood 10-18': [0.06,0.05,0.05,0.05,0.05,0.05,0.05]}, index=[10,50,100,1000,2800,'Euclidean', '1000 Avg0.99-1.01'])
  b.index.name = 'Slope Period'
  
  
  # Compute micro-average ROC curve and ROC area
    fpr["micro"], tpr["micro"], _ = roc_curve(y_test.ravel(), y_pred.ravel())
    roc_auc["micro"] = auc(fpr["micro"], tpr["micro"])

  # First aggregate all false positive rates
    all_fpr = np.unique(np.concatenate([fpr[i] for i in range(n_classes)]))

  # Then interpolate all ROC curves at this points
    mean_tpr = np.zeros_like(all_fpr)
    for i in range(n_classes):
        mean_tpr += np.interp(all_fpr, fpr[i], tpr[i])

  # Finally average it and compute AUC
    mean_tpr /= n_classes

    fpr["macro"] = all_fpr
    tpr["macro"] = mean_tpr
    roc_auc["macro"] = auc(fpr["macro"], tpr["macro"])

  # Plot all ROC curves
    plt.figure(figsize=(8,8),dpi=300)
    lw = 2
    plt.rcParams['font.size'] = '10'
    # plt.plot(fpr["micro"], tpr["micro"],
    #          label="micro-average ROC curve (area = {0:0.2f})".format(roc_auc["micro"]),
    #          color="pink", linestyle="-.", linewidth=4,)

    # plt.plot(fpr["macro"], tpr["macro"],
    #          label="macro-average ROC curve (area = {0:0.2f})".format(roc_auc["macro"]),
    #          color="purple", linestyle="-.", linewidth=4,)

    colors = cycle(["gray", "green", "blue", "yellow", "red",'black','brown','goldenrod','gold',
                    'aqua','violet','darkslategray','mistyrose','darkorange','tan'])
    for i, color in zip(range(n_classes), colors):
        plt.plot(fpr[i], tpr[i], color=color, lw=lw, linestyle="--",
                 label="ROC curve of class {0} (area = {1:0.2f} thresh = {2:0.2f})".format(i, roc_auc[i], opt_t[i,0]),zorder=1)
        plt.scatter(opt_t[i,2],opt_t[i,3], s=100, color='k', edgecolors='white', zorder=2)

    plt.plot([0, 1], [0, 1], "k--", lw=lw)
    plt.xlim([-0.05, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel("False Positive Rate")
    plt.ylabel("True Positive Rate")
    #plt.title("Receiver Operating Characteristic (ROC) curve")
    plt.legend()


plot_roc_curve(y_test,pred_proba)


# %%
fig, axs = plt.subplots(5,1,figsize=(4,20), sharex=False)

for col in np.arange(0,5):
    idx = np.where(y_test == col)[0]
    idy = np.where(y_test != col)[0]
    axs[col].hist(pred_proba[idx, col],cumulative=True, density = True, histtype='step')
    axs[col].hist(pred_proba[idy, col],cumulative=True, density = True, histtype='step')
    axs[col].set_xlabel('Majority Probability')
    axs[col].set_ylabel('Cumulative Proportion')
    axs[col].vlines(0.5, 0, 1, colors='k')


# %%

fig, axs = plt.subplots(5, 1, figsize=(5,40), sharex=True)
trt = np.arange(0,5)
a = 1
c = False
th = [0.37,0.34,0.11,0.21,0.05]
for i in trt:
    idy = np.where(y_test == i)[0]
    sns.histplot(prob.iloc[idy,0], color='gray', fill=False, element='poly', stat='proportion', cumulative=c, alpha=0.5, ax=axs[i], label='Untreated')
    axs[i].set_ylim([0,a])
    axs[0].set_title('Probability Histograms')
    sns.histplot(prob.iloc[idy,1], color='green', fill=False, element='poly', stat='proportion', cumulative=c, alpha=0.5, ax=axs[i], label='Removal 1-9 yrs')
    axs[i].set_ylim([0,a])
    sns.histplot(prob.iloc[idy,2], color='blue', fill=False, element='poly', stat='proportion', cumulative=c, alpha=0.5, ax=axs[i], label='Removal 10-18 yrs')
    axs[i].set_ylim([0,a])
    sns.histplot(prob.iloc[idy,3], color='yellow', fill=False, element='poly', stat='proportion', cumulative=c, alpha=0.5, ax=axs[i], label='Shelterwood 1-9 yrs')
    axs[i].set_ylim([0,a])
    sns.histplot(prob.iloc[idy,4], color='red', fill=False, element='poly', stat='proportion', cumulative=c, alpha=0.5, ax=axs[i], label='Shelterwood 10-18 yrs')
    axs[i].set_ylim([0.0001,a])
    axs[i].set_yscale('log')
    plt.xlabel('Prediction Probability')
    axs[0].legend()
    axs[i].vlines(th[i],0,1,'k',ls='--')
plt.tight_layout()






