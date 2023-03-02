#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 20 20:04:57 2022

@author: burch
"""
import os
import pandas as pd
import numpy as np
import geopandas
import rasterio
import rasterio.mask
import matplotlib.pyplot as plt
import numpy as np
from shapely.geometry import Point

import pylandstats as pls

# %%
# File paths
fp = '/Volumes/Bitcasa2/Forestbirds/Maj_filt/PA_pred_acc_rand_mostmets_dwmask_1_10_2000_thr_adj_sq10x10.tif'
abcshp = '/Users/burch/Sync/Work4SESYNC/QGIS/DJ_Stuff/ABC_BIRDSCAPES_all_3_6350_modified.shp'
sfbshp = '/Users/burch/Sync/Work4SESYNC/QGIS/RTH/PA_SFB_6350_mask.shp'
rthshp = '/Users/burch/Sync/Work4SESYNC/QGIS/RTH/PA_RTH_6350_mask.shp'
stpshp = '/Users/burch/Sync/Work4SESYNC/QGIS/DCNR_StateParks201703/DCNR_StateParks201703_6350.shp'
sglshp = '/Users/burch/Sync/Work4SESYNC/QGIS/PGC_StateGameland2021/PGC_StateGameland2021_6350.shp'
pagapshp = '/Users/burch/Sync/Work4SESYNC/QGIS/PA_GAP_stewardship/pa_gap_stewardship_1999_6350.shp'

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

mask = pr
 
za = pls.ZonalAnalysis(fp, masks=mask, masks_index_col="Birdscape")

class_metrics_pr = za.compute_class_metrics_df(metrics=["proportion_of_landscape", 'total_area'])   #, 'number_of_patches'
class_metrics_pr


class_metrics_df.xs('PA Wilds', level=1).sum()



# %% Make clipped rasters to extract point locations from the 10m pixels

# For the State Forest with the plus30m RTH clippped out 
with fiona.open("/Users/burch/Sync/Work4SESYNC/QGIS/RTH/SFB_symdiff_RTH_plus30m_clipby_SFB_mask.shp", "r") as shapefile:
    shapes = [feature["geometry"] for feature in shapefile]
    

with rasterio.open(fp) as src:
    out_image, out_transform = rasterio.mask.mask(src, pr.geometry[4], crop=True)
    out_meta = src.meta
    

out_meta.update({"driver": "GTiff",
                 "height": out_image.shape[1],
                 "width": out_image.shape[2],
                 "transform": out_transform})

with rasterio.open("/Volumes/Bitcasa2/Forestbirds/private_pa_wilds.tif", "w", **out_meta) as dest:
    dest.write(out_image)


# REMOVE ALL THE VARIABLES FROM ABOVE HERE
del(dest, out_image, out_meta, out_transform, shapefile, shapes, src)



# %% PyLandStats Landscape Patch Analysis

lsa = pls.Landscape("/Volumes/Bitcasa2/Forestbirds/public_pa_wilds.tif", neighborhood_rule='8')
lspu = lsa.area()

lsb = pls.Landscape("/Volumes/Bitcasa2/Forestbirds/private_pa_wilds.tif", neighborhood_rule='8')
lspr = lsb.area()


# %% Histogram

import seaborn as sns
import matplotlib as mpl
import matplotlib.pyplot as plt


# %%
fig, axs = plt.subplots(figsize = (5,25), nrows=5)
bins=8
rng = (0,4)
typ = 'bar'
alpha = 0.75
axs[0] = lspu[lspu["class_val"] == 0].hist(column="logarea", label="Untreated", cumulative=True, alpha=alpha, histtype=typ, range=rng, bins=bins, stacked=False, ax=axs[0])
axs[1] = lspu[lspu["class_val"] == 1].hist(column="logarea", label="Removal 1-9 yrs", alpha=alpha, histtype=typ, range=rng, bins=bins, stacked=False, ax=axs[1])
axs[2] = lspu[lspu["class_val"] == 2].hist(column="logarea", label="Removal 10-18 yrs", alpha=alpha, histtype=typ, range=rng, bins=bins, stacked=False, ax=axs[2])
axs[3] = lspu[lspu["class_val"] == 3].hist(column="logarea", label="Shelterwood 1-9 yrs", alpha=alpha, histtype=typ, range=rng, bins=bins, stacked=False, ax=axs[3])
axs[4] = lspu[lspu["class_val"] == 4].hist(column="logarea", label="Shelterwood 10-18 yrs", alpha=alpha, histtype=typ, range=rng, bins=bins, stacked=False, ax=axs[4])

#ax.item().get_xaxis().set_major_formatter(mpl.ticker.FuncFormatter(lambda x, p: "10^%d" % x))
#axs.legend()

# %%
ax = lspu.groupby("class_val").logarea.hist(alpha=0.4, range=rng, label=lspu.class_val.unique)
ax.legend(labels=[0,1,2,3,4])

iris.groupby("class_val").PetalWidth.hist(alpha=0.4, ax=axs[0])




sns.set_theme(style="ticks")


sns.despine(f)

sns.kdeplot(
   data=lspr, x=lspr.area, hue="class_val",
   fill=False, common_norm=False, palette="crest",
   alpha=1, linewidth=2, log_scale=[True,True]
)
plt.grid()
plt.title('Private Patches from PA Wilds Birdscape')


sns.histplot(
    lspu,
    x=lspu.area.apply(np.log10), hue="class_val",
    element="step",
    palette="light:m_r",
    edgecolor=".3",
    linewidth=.5,
    log_scale=False,
)

# ax.xaxis.set_major_formatter(mpl.ticker.ScalarFormatter())
# ax.set_xticks([500, 1000, 2000, 5000, 10000])


# %% Make clipped rasters to extract point locations from the 10m pixels

# For the Recently Harvested minus 30m data
with fiona.open(abcshp, "r") as shapefile:
    shapes = [feature["geometry"] for feature in shapefile]
    

with rasterio.open(fp) as src:
    out_image, out_transform = rasterio.mask.mask(src, shapes, crop=False)
    out_meta = src.meta
    

out_meta.update({"driver": "GTiff",
                 "height": out_image.shape[1],
                 "width": out_image.shape[2],
                 "transform": out_transform})

with rasterio.open("/Users/burch/Desktop/poop.tif", "w", **out_meta) as dest:
    dest.write(out_image)
