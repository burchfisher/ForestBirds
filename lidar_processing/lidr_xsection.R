# lidr_metrics.R
# Date last Edit:  October 5, 2022 by G. Burch Fisher
# author:  G. Burch Fisher
################################################################################
#
# Description
# This script creates a x-section of lidar returns using the lidR package

# packages
require(lidR)
require(rgl)

# set the working directory
setwd("/Users/burch/Desktop")

shelt2yr="USGS_LPC_PA_WesternPA_2019_D20_17TPF663575.laz"
shelt7yr="USGS_LPC_PA_Northcentral_2019_B19_e1499n2138.laz"
rem2yr_11yr = "USGS_LPC_PA_Northcentral_2019_B19_e1513n2219.laz"
shelt14yr = "USGS_LPC_PA_Northcentral_2019_B19_e1490n2173.laz"

# read in LAS/LAZ file and plot 
las <- lidR::readLAS(shelt7yr)

# normalize the lidar returns using tin method an filter out points below 0 and >= 50
las.norm <- lidR::normalize_height(las, algorithm = tin(), na.rm = TRUE, method = "bilinear")
las.norm = las.norm[(las.norm$Z >= 0) & (las.norm$Z < 40)]
plot(las.norm, size = 3, bg = "white",legend=TRUE, axis=FALSE)

# use this to extract the view parameters from the plot above after getting it how you like 
pp <- par3d(no.readonly=TRUE)

# use this to orient other plots based on the set parameters above 
par3d(pp)

# to save the plots above
rgl.snapshot('3dplot.png', fmt = 'png')

# plot just ground points
gnd <- filter_ground(las)
plot(gnd, size = 3, bg = "white", color = "Classification")

# extract points along a transect using p1 and p2
tr_width = 10
p1 <- c(1721680.02,2207292.57)
p2 <- c(1721780.83,2207405.74)
las_tr <- clip_transect(las.norm, p1, p2, width = tr_width, xz = TRUE)  

# plot transect  
ggplot(las_tr@data, aes(X,Z, color = Z)) + 
  geom_point(size = 0.5) + 
  coord_equal() + 
  theme_classic() +
  scale_color_gradientn(colours = height.colors(50))