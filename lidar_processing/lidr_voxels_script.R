# lidr_metrics.R
# Date last Edit:  March 31, 2022 by G. Burch Fisher
# author:  jeff w. atkins (quentin d. read parallelized the code)
################################################################################
#
# Description
#
# This script creates a series of custom, gridded lidar metrics from raw .laz files 
# the MyMetrics function calculates these metrics with the output in the form of
# a RasterStack which is saved as a GeoTiff

# packages
require(lidR)
require(raster)
require(sp)
require(rgdal)
require(rslurm)
require(lubridate)

# Delivery Areas
# DE1 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/DelawareValleyHD_2015/LAZ", pattern = ".laz", full.names = TRUE)
# DE2 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/DelawareValleyHD_5A_2015/LAZ", pattern = ".laz", full.names = TRUE)
# PA1.1 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/PA_South_Central_B1_2017/LAZ", pattern = ".laz", full.names = TRUE)
# PA1.2 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/PA_South_Central_B2_2017/LAZ", pattern = ".laz", full.names = TRUE)
# PA2 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/PA_3_County_South_Central_2018/LAZ", pattern = ".laz", full.names = TRUE)
# PA4.1 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/PA_Northcentral_2019_B19/PA_Northcentral_B1_2019/LAZ", pattern = ".laz", full.names = TRUE)
# PA4.2 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/PA_Northcentral_2019_B19/PA_Northcentral_B2_2019/LAZ", pattern = ".laz", full.names = TRUE)
# PA4.3 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/PA_Northcentral_2019_B19/PA_Northcentral_B3_2019/LAZ", pattern = ".laz", full.names = TRUE)
# PA4.4 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/PA_Northcentral_2019_B19/PA_Northcentral_B4_2019/LAZ", pattern = ".laz", full.names = TRUE)
# PA4.5 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/PA_Northcentral_2019_B19/PA_Northcentral_B5_2019/LAZ", pattern = ".laz", full.names = TRUE)
# PA5 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/PA_Sandy_2014/LAZ", pattern = ".laz", full.names = TRUE)
# PA6 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/westernPa_1/LAZ", pattern = ".laz", full.names = TRUE)
# PA7 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/westernPa_2/LAZ", pattern = ".laz", full.names = TRUE)
# PA8 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/westernPa_4/LAZ", pattern = ".laz", full.names = TRUE)
# PA9 <- list.files(path = "/nfs/forestbirds-data/pa_lidar/westernPa_3/LAZ", pattern = ".laz", full.names = TRUE)


# 
# file.list = c("/nfs/forestbirds-data/pa_lidar/PA_South_Central_B2_2017/LAZ/USGS_LPC_PA_South_Central_B2_2017_18TUL322540_LAS_2019.laz",
#     "/nfs/forestbirds-data/pa_lidar/PA_South_Central_B2_2017/LAZ/USGS_LPC_PA_South_Central_B2_2017_18TUL322542_LAS_2019.laz",
#     "/nfs/forestbirds-data/pa_lidar/PA_South_Central_B2_2017/LAZ/USGS_LPC_PA_South_Central_B2_2017_18TUL322543_LAS_2019.laz",
#     "/nfs/forestbirds-data/pa_lidar/PA_South_Central_B2_2017/LAZ/USGS_LPC_PA_South_Central_B2_2017_18TUL324540_LAS_2019.laz",
#     "/nfs/forestbirds-data/pa_lidar/PA_South_Central_B2_2017/LAZ/USGS_LPC_PA_South_Central_B2_2017_18TUL324542_LAS_2019.laz",
#     "/nfs/forestbirds-data/pa_lidar/PA_South_Central_B2_2017/LAZ/USGS_LPC_PA_South_Central_B2_2017_18TUL324543_LAS_2019.laz",
#     "/nfs/forestbirds-data/pa_lidar/PA_South_Central_B2_2017/LAZ/USGS_LPC_PA_South_Central_B2_2017_18TUL325540_LAS_2019.laz",
#     "/nfs/forestbirds-data/pa_lidar/PA_South_Central_B2_2017/LAZ/USGS_LPC_PA_South_Central_B2_2017_18TUL325542_LAS_2019.laz",
#     "/nfs/forestbirds-data/pa_lidar/PA_South_Central_B2_2017/LAZ/USGS_LPC_PA_South_Central_B2_2017_18TUL325543_LAS_2019.laz")

##### MAKE FOLDERS
# dir.create('/nfs/forestbirds-data/processed/DelawareValleyHD_2015')
# dir.create('/nfs/forestbirds-data/processed/DelawareValleyHD_5A_2015')
# dir.create("/nfs/forestbirds-data/processed/pa_dauphin_2016")
# dir.create("/nfs/forestbirds-data/processed/PA_3_County_South_Central_2018")
# dir.create("/nfs/forestbirds-data/processed/westernPa_1")
# dir.create("/nfs/forestbirds-data/processed/westernPa_2")
# dir.create("/nfs/forestbirds-data/processed/westernPa_4")

# dir.create("/nfs/forestbirds-data/processed/Northcentral_B1")
# dir.create("/nfs/forestbirds-data/processed/Northcentral_B2")
# dir.create("/nfs/forestbirds-data/processed/Northcentral_B3")
# dir.create("/nfs/forestbirds-data/processed/Northcentral_B4")
# dir.create("/nfs/forestbirds-data/processed/Northcentral_B5")
# 
# dir.create("/nfs/forestbirds-data/processed/PA_South_Central_B1_2017")
# dir.create("/nfs/forestbirds-data/processed/PA_South_Central_B2_2017")

# dir.create("/nfs/forestbirds-data/processed/Luzerne_2018")


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
    # total returns
    v2 = (sum(z>=0 & z<2) / nz) * 100,
    v4 = (sum(z>=2 & z<4) / nz) * 100,
    v6 = (sum(z>=4 & z<6) / nz) * 100,
    v8 = (sum(z>=6 & z<8) / nz) * 100,
    v10 = (sum(z>=8 & z<10) / nz) * 100,
    v12 = (sum(z>=10 & z<12) / nz) * 100,
    v14 = (sum(z>=12 & z<14) / nz) * 100,
    v16 = (sum(z>=14 & z<16) / nz) * 100,
    v18 = (sum(z>=16 & z<18) / nz) * 100,
    v20 = (sum(z>=18 & z<20) / nz) * 100,
    v22 = (sum(z>=20 & z<22) / nz) * 100,
    v24 = (sum(z>=22 & z<24) / nz) * 100,
    v26 = (sum(z>=24 & z<26) / nz) * 100,
    v28 = (sum(z>=26 & z<28) / nz) * 100,
    v30 = (sum(z>=28 & z<30) / nz) * 100,
    v32 = (sum(z>=30 & z<32) / nz) * 100,
    v34 = (sum(z>=32 & z<34) / nz) * 100,
    v36 = (sum(z>=34 & z<36) / nz) * 100,
    v38 = (sum(z>=36 & z<38) / nz) * 100,
    v40 = (sum(z>=38 & z<40) / nz) * 100,
    v42 = (sum(z>=40 & z<42) / nz) * 100,
    v44 = (sum(z>=42 & z<44) / nz) * 100,
    v46 = (sum(z>=44 & z<46) / nz) * 100,
    v48 = (sum(z>=46 & z<48) / nz) * 100,
    v50 = (sum(z>=48 & z<=50) / nz) * 100)
  
  # return all them boys
  return(metrics)
}

################################################################################
# Function taking one file name as argument.
# Reads the file and calculates grid metrics then
#   saves each raster stack as a .tif file

process_lidar_file <- function(file.name, out_dir) {
  
  # imports files and then cleans duplicates
  las <- lidR::readLAS(file.name, filter = "-keep_class 1 2 3 4 5")
  las <- lidR::filter_duplicates(las)
  las <- las[las$Overlap_flag==FALSE]
  las <- las[las$Withheld_flag==FALSE]
  
  # normalize heights
  las.norm <- lidR::normalize_height(las, algorithm = tin(), na.rm = TRUE, method = "bilinear")
  
  # # remove big ol' files to clear memory
  rm(las)
  
  # custom metrics function, note input variables and resolution, which is set at 10 as in 10 meters
  metrics <- lidR::grid_metrics(las.norm, ~myMetrics(z = Z, rn=ReturnNumber, i = Intensity, g = gpstime, c = Classification), 
                                start = c(0, 0), res = 10, filter = ~Z >=0 & Z <= 50 )    
  
  
  # Before we save the files, we need to name them
  # make sure to edit the value in there. also, overwrite is set to TRUE
  # so if you don't change that, you will write over your data
  out.file.name <- file.path(out_dir, paste(substr(basename(file.name), 1, nchar(basename(file.name)) - 4), ".tif", sep = ""))
  
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

slurm_job <- slurm_map(as.list(PA1.2), process_lidar_file, jobname = 'PA1.2_vox', 
                       nodes = 10, cpus_per_node = 8, 
                       global_objects = c('myMetrics'), 
                       out_dir = '/nfs/forestbirds-data/Voxels/PA_South_Central_B2')


# RUNNING THE ERROR LIST
slurm_job_error <- slurm_map(as.list(error.list), process_lidar_file, jobname = 'error', 
                             nodes = 10, cpus_per_node = 8, 
                             global_objects = c('myMetrics'), 
                             out_dir = '/nfs/forestbirds-data/Voxels/PA_South_Central_B2')


# After job is run, you can either manually delete the temporary job folder in your working directory
# which will be called _rslurm_process_lidar, or delete it this way:

cleanup_files(slurm_job)
cleanup_files(slurm_job_error)


################################################################################
# MISCELLANEOUS CODE

# To run the error.list files so that any error (usually "Error : No ground points found. Impossible to compute a DTM.") 
# doesn't kick out of processing the additional files as happens with the slurm code above.
# NOTE: This is not fast so if there are a bunch of files, like 100s better to use SLURM until the number is reduced to like 20-40 or so

y = '/nfs/forestbirds-data/pa_lidar/westernPa_4/LAZ/USGS_LPC_PA_WesternPA_2019_D20_17TNG597636.laz'
out_dir = '/nfs/forestbirds-data/Voxels/Western124'

for (x in 1:length(y)) {
  print(100*(x/length(y)), digits=2)
  try({process_lidar_file(y[x], out_dir)})
}

# To remove LAS files that gave errors before downloading again from USGS
file.remove(NC1error.list)
