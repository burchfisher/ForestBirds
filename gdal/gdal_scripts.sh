# Shell Scripts for FORESTBIRDS GDAL Programs

# find *.tif -maxdepth 1 -type f > list.txt

# METRIC RASTER NAMES
# NAMES="Below1m.tif Below2m.tif Below5m.tif DiffTime.tif FirstBelow1m.tif FirstBelow2m.tif FirstBelow5m.tif IQR.tif MOCH.tif
# MaxTime.tif MinTime.tif NumFirst.tif NumFirstGround.tif NumGround.tif NumPoints.tif Perc_2m_to_1m.tif Perc_5m_to_1m.tif Perc_5m_to_2m.tif
# Perc_First_2m_to_1m.tif Perc_First_5m_to_1m.tif Perc_First_5m_to_2m.tif TopRug.tif TopRug30m_MOCH.tif TopRug30m_p95.tif TopRug30m_p99.tif 
# TopRug50m_MOCH.tif TopRug50m_p95.tif TopRug50m_p99.tif p5.tif p10.tif p25.tif p50.tif p75.tif p90.tif p95.tif p99.tif"

# VOXEL RASTER NAMES
NAMES="V2.tif V4.tif V6.tif V8.tif V10.tif V12.tif V14.tif V16.tif V18.tif V20.tif
V22.tif V24.tif V26.tif V28.tif V30.tif V32.tif V34.tif V36.tif V38.tif V40.tif V42.tif V44.tif V46.tif V48.tif V50.tif"


######### EXTRACT RASTER DATA USING SHAPEFILE MASK ############
IN="/Volumes/Bitcasa2/Forestbirds/Lidar/Voxels/PA_2m_voxels/"
OUT="/Volumes/Bitcasa2/Forestbirds/Lidar/Voxels/Cam_2m_voxels/"
SHAPE="/Users/burch/Desktop/ForLarkin/all_blocks_2022_epsg6350_buffer5km_PAmask.shp"

for f in $NAMES
do
  gdalwarp -s_srs EPSG:6350 -t_srs EPSG:6350 -cutline $SHAPE -crop_to_cutline -dstnodata -9999.0 $IN$f $OUT$f
done


######### SET NO DATA VALUES TO 0 ############
# IN="/Volumes/Bitcasa2/Forestbirds/Lidar/PA_metrics/"
# OUT="/Volumes/Bitcasa2/Forestbirds/Lidar/"
# 
# for f in $NAMES 
# do 
#   gdal_calc.py --overwrite --calc "where(A<=-9999.0,-9999.0,A)" --format GTiff --type Float32 --NoDataValue -9999.0 -A $IN$f --A_band 1 --outfile $OUT$f
# done


######### RASTER REPROJECT ############
# IN="/Volumes/Bitcasa2/Forestbirds/Lidar/PA_metrics/"
# OUT="/Volumes/Bitcasa2/Forestbirds/Lidar/"

# for f in $NAMES
# do
#   gdalwarp -overwrite -s_srs EPSG:6350 -t_srs EPSG:6350 -of GTiff -dstnodata -9999.0 $IN$f $OUT$f
# done

