# lidr_error_check_script.R
# Date last Edit:  7/6/2022
# author:  G. Burch Fisher
###################################

require(tools)

# LAS/LAZ files and TIF directories
tif.dir = "/nfs/forestbirds-data/Voxels/PA_South_Central_B2"
tif.names = list.files(path = tif.dir, pattern=".tif", full.names=TRUE)
las.names = PA1.2

# Get the length of tif files created and the input las/laz files
length(tif.names)
length(las.names)

# Create error list for rerun
error.list <- las.names[!file_path_sans_ext(basename(las.names)) %in% file_path_sans_ext(basename(tif.names))]

