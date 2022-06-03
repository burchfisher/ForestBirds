# lidr_metrics.R
# Date last Edit:  March 28, 2022 by G. Burch Fisher
# author:  jeff w. atkins (quentin d. read parallelized the code)
################################################################################
#
# Description
#
# This script creates a series of custom, gridded lidar metrics from raw .laz files 
# the MyMetrics function calculates these metrics with the output in the form or
# a RasterStack which is saved as a GeoTiff

# packages
require(lidR)
require(raster)
require(sp)
require(rgdal)
require(rslurm)
require(lubridate)

# Delivery Areas
PA3 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/pa_dauphin_2016/LAZ", pattern = ".laz", full.names = TRUE)
PA9 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/PA_luzerne_county_2018/LAZ", pattern = ".laz", full.names = TRUE)

##### MAKE FOLDERS
# dir.create("/nfs/forestbirds-data/processed/pa_dauphin_2016")

# find this file
# grep("USGS_LPC_PA_Northcentral_2019_B19_e1562n2215", PA4.5)
# file.name <- PA4.5[13576]
# file.name <- "/nfs/forestbirds-data/pa_lidar/PA_Northcentral_2019_B19/PA_Northcentral_B5_2019/LAZ/USGS_LPC_PA_Northcentral_2019_B19_e1710n2234.laz"


################################################################################
# Custom function to work with lidR::grid_metrics()
# z = Z, height, rn = ReturnNumber, i = Intensity, g = gpstime, c = Classification

myMetrics <- function(z, rn, i, a, g, c){
  first  = rn == 1L
  zfirst = z[first]
  nfirst = length(zfirst)
  
  ground = c == 2
  zground = z[ground]
  nground = length(zground)
  
  firstground = rn == 1L & c == 2
  zfirstground = z[firstground]
  nfirstground = length(zfirstground)
  nz = length(z)
  
  metrics = list(
    # MeanAngle = mean(a),
    # MedAngle = median(a),
    # MaxAngle = max(a),
    NoPoints = length(z),
    NoGround = nground,
    NoFirst = nfirst,
    NoFirstGround =  nfirstground,
    iqr =  IQR(z), # inter-quartile range
    # vci = VCI(z, zmax = max(z)), # vertical complexity index
    # entropy = entropy(z, zmax = max(z)),
    # fhd =   (entropy(z, zmax = max(z)) * log(max(z))),  #foliar height diversity
    # vdr = ((max(z) - median(z)) / max(z)),
    top_rug = sd(zfirst),
    # meanht = mean(z),
    # medht = median(z),
    moch = mean(zfirst),
    # skew = (3 * (mean(z) - median(z)) / sd(z)), # Skew = 3 * (Mean – Median) / Standard Deviation
    firstbelow1 = (sum(zfirst < 1) / nfirst) * 100,
    firstbelow2 = (sum(zfirst < 2) / nfirst) * 100,
    firstbelow5 = (sum(zfirst < 5) / nfirst) * 100,
    # total returns
    below1 = (sum(z < 1) / nz) * 100,
    below2 = (sum(z < 2) / nz) * 100,
    below5 = (sum(z < 5) / nz) * 100,
    # cc = 100 - ((sum(z < 2) / nz) * 100),
    # crr = (mean(z) - min(z)) / (max(z) - min(z)),
    p5 = quantile(z, probs = 0.05),
    p10 = quantile(z, probs = 0.1),
    p25 = quantile(z, probs = 0.25),
    p50 = quantile(z, probs = 0.5),
    p75 = quantile(z, probs = 0.75),
    p90 = quantile(z, probs = 0.9),
    p95 = quantile(z, probs = 0.95),
    p99 = quantile(z, probs = 0.99),
    maxtimeint = strtoi(gsub('[-]', '', substr(lubridate::as_datetime(1315576000+max(g)),3,10))),    #Converts GPS time to UTC time
    mintimeint = strtoi(gsub('[-]', '', substr(lubridate::as_datetime(1315576000+min(g)),3,10))),    #Converts GPS time to UTC time
    difftime = (max(g) - min(g))/86400)      #Time difference in days
      
  # return all them boys
  return(metrics)
}

################################################################################
# Function taking one file name as argument.
# Reads the file and calculates grid metrics then
#   saves each raster stack as a .tif file

process_lidar_file <- function(file.name, out_dir) {
  
  ft2m = 1200/3937
  
  # imports files and then cleans duplicates
  las <- lidR::readLAS(file.name, filter = "-keep_class 1 2 3 4 5")
  las <- lidR::filter_duplicates(las)
  las <- las[las$Overlap_flag==FALSE]
  las <- las[las$Withheld_flag==FALSE]
  
  las$Z = las$Z * ft2m
  
  # normalize heights
  las.norm <- lidR::normalize_height(las, algorithm = tin(), na.rm = TRUE, method = "bilinear")
  
  # # remove big ol' files to clear memory
  rm(las)
  
  # custom metrics function, note input variables and resolution, which is set at 10 as in 10 meters
  metrics <- lidR::grid_metrics(las.norm, ~myMetrics(z = Z, rn=ReturnNumber, i = Intensity, g = gpstime, c = Classification), 
                                start = c(0, 0), res = 5000/152, filter = ~Z >=0 & Z <= 50 )    

  
  # Before we save the files, we need to name them
  # make sure to edit the value in there. also, overwrite is set to TRUE
  # so if you don't change that, you will write over your data
  out.file.name <- file.path(out_dir, paste(substr(basename(file.name), 1, nchar(basename(file.name)) - 4), "_metrics_10m.tif", sep = ""))
  
  # writes metrics file raster stack to disk
  writeRaster(metrics, out.file.name, format = "GTiff", overwrite = TRUE)
  
  # # this snippet let's you know how many more .laz files are left to process and what time it is
  # message("how many las files left")
  # print(length(file.names) - i)
  # print(Sys.time())
  
}


################################################################################
# Parallelize with rslurm
# You can modify the slurm_options, number of nodes, and cpus per node if desired.
# 6 is a good number of nodes to use because your job will run fast enough but it will leave some for other people to use.
# You have to pass the myMetrics object to the environment on the slurm node using the global_objects argument
# partition='sesync' is not strictly necessary but will ensure your job can run for more than 14 days (likely overkill!)

slurm_job <- slurm_map(as.list(PA9), process_lidar_file, jobname = 'PA9', 
                          nodes = 14, cpus_per_node = 8, 
                          global_objects = c('myMetrics'), 
                          out_dir = '/nfs/forestbirds-data/processed/Luzerne_2018')


# RUNNING THE ERROR LIST
slurm_job_error <- slurm_map(as.list(error.list), process_lidar_file, jobname = 'error', 
                                 nodes = 14, cpus_per_node = 8, 
                                 global_objects = c('myMetrics'), 
                                 out_dir = '/nfs/forestbirds-data/processed/pa_dauphin_2016')


# After job is run, you can either manually delete the temporary job folder in your working directory
# which will be called _rslurm_process_lidar, or delete it this way:

cleanup_files(slurm_job)
cleanup_files(slurm_job_error)


################################################################################
# MISCELLANEOUS CODE

# To run the error.list files so that any error (usually "Error : No ground points found. Impossible to compute a DTM.") 
# doesn't kick out of processing the additional files as happens with the slurm code above.
# NOTE: This is not fast so if there are a bunch of files, like 100s better to use SLURM until the number is reduced to like 20-40 or so

y = PA8error.list
out_dir = '/nfs/forestbirds-data/processed/pa_dauphin_2016'

for (x in 1:length(y)) {
  print(100*(x/length(y)), digits=2)
  try({process_lidar_file(y[x], out_dir)})
}

# To remove LAS files that gave errors before downloading again from USGS
file.remove(NC1error.list)
