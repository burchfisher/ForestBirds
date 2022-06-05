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

# Remove data where YRDiff is >20
df = df[df.YRDiff < 19]

# Create 5 Categories
df.Treat_fact[df.Treatment == 'Untreated'] = 0
df.Treat_fact[(df.YRDiff < 10) & (df.Treatment == 'Removal')] = 1
df.Treat_fact[(df.YRDiff >9) & (df.Treatment == 'Removal')] = 2
df.Treat_fact[(df.YRDiff < 10) & (df.Treatment == 'Shelterwood')] = 3
df.Treat_fact[(df.YRDiff >9) & (df.Treatment == 'Shelterwood')] = 4

labels=['Untreated','Removal 1-9 yrs','Removal 10-18 yrs','Shelterwood 1-9 yrs', 'Shelterwood 10-18 yrs']

# Sample an even number of each category for xgboost and creating a confusion matrix
def equal_treat(df):
    cats = df.Treat_fact.unique()
    n = df.Treat_fact.value_counts().min()
    xgb = pd.DataFrame()
    
    for val in cats:
        d = df[df.Treat_fact == val].sample(n=n, random_state=1)
        if xgb.empty:
            xgb = d
        else: 
            xgb = pd.concat([xgb,d], ignore_index=False)
        
    return xgb
    
xgb = equal_treat(df)

# %% XGBOOST

# split data into X and y
X = xgb.loc[:,'xcoord':'aspect']
y = xgb.Treat_fact

# Split withheld data for predicting on after establishing the model
xgb2 = df[~df.index.isin(xgb.index)]
X2 = xgb2.loc[:,'xcoord':'aspect']
y2 = xgb2.Treat_fact


# Test Train Split the data
X_train, X_test, y_train, y_test = train_test_split(X, y,
    test_size=0.25, random_state=7)

# fit model on training data
model = XGBClassifier(max_depth=9, n_estimators=200, learning_rate=1, base_score=0.5, 
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

# evaluate predictions
accuracy = accuracy_score(y_test, predictions)
print("Accuracy: %.2f%%" % (accuracy * 100.0))

# confusion matrix and report
ConfusionMatrixDisplay.from_predictions(y_test, predictions, normalize=None, display_labels=labels)
plt.title('XGBoost with equal # of samples \n (259191 samples per category)')
plt.xticks(rotation = 45)
plt.yticks(rotation = 45)
plt.tight_layout(h_pad=0)
plt.show()

print(classification_report(y_test, predictions, target_names=labels))

# save model in JSON format
model.save_model("XGB_model_sklearn.txt")

# to load model
model = XGBClassifier()
model.load_model("XGB_model_sklearn.txt")

# Make predcition on withheld data
xgb2 = df[~df.index.isin(xgb.index)]
X2 = xgb2.loc[:,'xcoord':'aspect']
y2 = xgb2.Treat_fact

# make predictions for test data
predictions2 = model.predict(X2)

# evaluate predictions
accuracy = accuracy_score(y2, predictions2)
print("Accuracy: %.2f%%" % (accuracy2 * 100.0))

print(classification_report(y2, predictions2, target_names=labels))

# %% GridSearch to tune hyperparameters

# Grid Search
# eta = []
# maxd = []
# trees = []
# acc = []
# best_acc = 0

for max_depth in [10]:
    for n_estimators in [600, 800, 1000]:
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


GS1 = pd.DataFrame({'eta':eta,'maxd':maxd,'trees':trees,'acc':acc})
GS1.to_pickle('GS1.pkl')

# %%





