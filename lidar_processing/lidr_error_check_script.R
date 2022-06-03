# lidr_error_check_script.R
# Date last Edit:  March 06, 2022
# author:  G. Burch Fisher
###################################

# LAS/LAZ and TIF directories
las.dir = "/nfs/forestbirds-data/pa_lidar/westernPa_3/LAZ"
tif.dir = "/nfs/forestbirds-data/processed/westernPa_3"

# las.dir = "/nfs/forestbirds-data/pa_lidar/PA_Northcentral_2019_B19/PA_Northcentral_B2_2019/LAZ"
# tif.dir = "/nfs/forestbirds-data/processed/Northcentral_B2"

# Get lists of the Tif and LAS files
tif.names = list.files(path = tif.dir, pattern=".tif", full.names=TRUE) 
las.names = list.files(path = las.dir, pattern=".laz", full.names=TRUE)

# Get the length of tif files created and the input las/laz files
length(tif.names)
length(las.names)

# Create a list of the missing tifs
# For Luzerne data
# error.list <- las.names[!substr(las.names,59,107) %in% substr(tif.names,46,93)]

# For pa_dauphin data
# error.list <- las.names[!substr(las.names,52,96) %in% substr(tif.names,49,93)]

# For Northcentral data
# error.list <- las.names[!substr(las.names,85,128) %in% substr(tif.names,49,92)]

# For Western PA data
# error.list <- las.names[!substr(las.names,48,89) %in% substr(tif.names,45,86)]

# For Western PA 3 data
error.list <- las.names[!substr(las.names,48,91) %in% substr(tif.names,45,88)]

# For DelawareValley 5A data
# error.list <- las.names[!substr(las.names,61,117) %in% substr(tif.names,58,114)]

# For DelawareValley data
# error.list <- las.names[!substr(las.names,58,112) %in% substr(tif.names,55,109)]

# For PA_South_Central data
# error.list <- las.names[!substr(las.names,61,114) %in% substr(tif.names,58,111)]



