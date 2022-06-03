#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script to prepare, test, and run xgboost on the Recent Harvest Treatment dataset based on the 1-5 year treatment data 

Created on Thu May 12 21:43:45 2022

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
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.inspection import permutation_importance
import shap

# %% XGBOOST

os.chdir('/Volumes/Bitcasa2/Forestbirds/GBoost')

# load data
df = pd.read_pickle('df_gboost.pkl')

# split data into X and y
xgb = df[(df.YRDiff.isin([1,2,3,4,5]) == 1) | (df.YRDiff == -100)]
X = xgb.loc[:,'xcoord':'aspect']
y = xgb.Treat_fact

# Test Train Split the data
X_train, X_test, y_train, y_test = train_test_split(X, y,
    test_size=0.25, random_state=7)

# fit model on training data
model = XGBClassifier(use_label_encoder=False)
model.fit(X_train, y_train)
print(model)

# make predictions for test data
predictions = model.predict(X_test)

# evaluate predictions
accuracy = accuracy_score(y_test, predictions)
print("Accuracy: %.2f%%" % (accuracy * 100.0))


sorted_idx = model.feature_importances_.argsort()
plt.barh(df.columns[sorted_idx], model.feature_importances_[sorted_idx])
plt.xlabel("Xgboost Feature Importance")



perm_importance = permutation_importance(model, X_test, y_test)

sorted_idx = perm_importance.importances_mean.argsort()
plt.barh(df.columns[sorted_idx], perm_importance.importances_mean[sorted_idx])
plt.xlabel("Permutation Importance")


def correlation_heatmap(train):
    correlations = train.corr()

    fig, ax = plt.subplots(figsize=(10,10))
    sns.heatmap(correlations, vmax=1.0, center=0, fmt='.2f', cmap="YlGnBu",
                square=True, linewidths=.5, annot=True, cbar_kws={"shrink": .70}
                )
    plt.show();
    
correlation_heatmap(X_train[df.columns[sorted_idx]])

explainer = shap.TreeExplainer(model)
shap_values = explainer.shap_values(X_test)

shap.summary_plot(shap_values, X_test, plot_type="bar")

shap.summary_plot(shap_values, X_test)

# Finding the mismatch between labels and predicitons
idx = np.where(np.equal(y_test, predictions))

# %% Testing on the >6 year Treatment data
# split data into X and y
# split data into X and y
xgb2 = df[df.YRDiff > 5]
X2 = xgb2.loc[:,'xcoord':'aspect']
y2 = xgb2.Treat_fact

predictions2 = model.predict(X2)

accuracy2 = accuracy_score(y2, predictions2)
print("Accuracy: %.2f%%" % (accuracy2 * 100.0))


# Finding the mismatch between labels and predicitons
idx2 = np.where(np.equal(Yt, predictions2))

df2res = xgb2.copy()
df2res['Treat_fact'] = y2
df2res['Predict'] = predictions2
df2res['predeq'] = np.equal(df2res.Predict, df2res.Treat_fact)
df2res['YRDiff'] = xgb2.YRDiff

df2res.predeq.loc[(df2res.YRDiff > 20) & (df2res.YRDiff < 26)].sum()/df2res.predeq.loc[(df2res.YRDiff > 20) & (df2res.YRDiff < 26)].count()

df2res.predeq.loc[df2res.YRDiff == 11].sum()/df2res.predeq.loc[df2res.YRDiff == 11].count()

group = ['6-10', '11-15', '16-20', '21-25']
acc = [0.65, 0.28, 0.23, 0.0004]

accg = pd.DataFrame({"Group": group, "Accuracy": acc})

sns.barplot(x=accg.Group, y=accg.Accuracy)
plt.text(0.9,0.9,'Mean Accuracy = 0.53')


df2res.YRDiff.hist()
plt.xlabel('Treatment Age (years)')
plt.ylabel('count')






