# Shell Scripts for FORESTBIRDS GDAL Programs

# find *.tif -maxdepth 1 -type f > list.txt

# METRIC RASTER NAMES
NAMES="Below1m.tif Below2m.tif Below5m.tif DiffTime.tif FirstBelow1m.tif FirstBelow2m.tif FirstBelow5m.tif IQR.tif MOCH.tif
MaxTime.tif MinTime.tif NumFirst.tif NumFirstGround.tif NumGround.tif NumPoints.tif Perc_2m_to_1m.tif Perc_5m_to_1m.tif Perc_5m_to_2m.tif
Perc_First_2m_to_1m.tif Perc_First_5m_to_1m.tif Perc_First_5m_to_2m.tif TopRug.tif TopRug30m_MOCH.tif TopRug30m_p95.tif TopRug30m_p99.tif 
TopRug50m_MOCH.tif TopRug50m_p95.tif TopRug50m_p99.tif p5.tif p10.tif p25.tif p50.tif p75.tif p90.tif p95.tif p99.tif"


######### EXTRACT RASTER DATA USING SHAPEFILE MASK ############
IN="/Volumes/Bitcasa2/Forestbirds/Lidar/PA_metrics/"
OUT="/Volumes/Bitcasa2/Forestbirds/Lidar/"
SHAPE="/Users/burch/Desktop/2019_2020_ALLBIRDS_95KDE_5km_buffer.shp"

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
#   gdal_calc.py --overwrite --calc "where(A<=-9999,-9999,A)" --format GTiff --type Float32 --NoDataValue -9999.0 -A $IN$f --A_band 1 --outfile $OUT$f
# done


######### RASTER REPROJECT ############
# IN="/Volumes/Bitcasa2/Forestbirds/Lidar/PA_metrics/"
# OUT="/Volumes/Bitcasa2/Forestbirds/Lidar/"

# for f in $NAMES
# do
#   gdalwarp -overwrite -s_srs EPSG:6350 -t_srs EPSG:6350 -of GTiff -dstnodata -9999.0 $IN$f $OUT$f
# done
