# GDAL SCRIPT FOR EXTRACTING BANDS FROM RASTER STACKS

# Make list of TIFs
# find /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/regions_6350 -name "*.tif" > /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt

# Make VRTs of each metric
gdalbuildvrt -b 1 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/NumPoints_10m.vrt
gdalbuildvrt -b 2 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/NumGround_10m.vrt
gdalbuildvrt -b 3 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/NumFirst_10m.vrt
gdalbuildvrt -b 4 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/NumFirstGround_10m.vrt
gdalbuildvrt -b 5 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/IQR_10m.vrt

gdalbuildvrt -b 6 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/TopRug_10m.vrt
gdalbuildvrt -b 7 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/MOCH_10m.vrt
gdalbuildvrt -b 8 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/FirstBelow1m_10m.vrt
gdalbuildvrt -b 9 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/FirstBelow2m_10m.vrt
gdalbuildvrt -b 10 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/FirstBelow5m_10m.vrt

gdalbuildvrt -b 11 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/Below1m_10m.vrt
gdalbuildvrt -b 12 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/Below2m_10m.vrt
gdalbuildvrt -b 13 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/Below5m_10m.vrt
gdalbuildvrt -b 14 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p5_10m.vrt
gdalbuildvrt -b 15 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p10_10m.vrt

gdalbuildvrt -b 16 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p25_10m.vrt
gdalbuildvrt -b 17 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p50_10m.vrt
gdalbuildvrt -b 18 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p75_10m.vrt
gdalbuildvrt -b 19 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p90_10m.vrt
gdalbuildvrt -b 20 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p95_10m.vrt

gdalbuildvrt -b 21 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p99_10m.vrt
gdalbuildvrt -b 22 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/MaxTime_10m.vrt
gdalbuildvrt -b 23 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/MinTime_10m.vrt
gdalbuildvrt -b 24 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/DiffTime_10m.vrt
gdalbuildvrt -b 24 -input_file_list /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/list.txt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/DiffTime_10m.vrt


# Making TIFs from VRTs
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/NumPoints_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/NumPoints_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/NumGround_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/NumGround_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/NumFirst_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/NumFirst_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/NumFirstGround_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/NumFirstGround_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/IQR_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/IQR_10m.tif

gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/TopRug_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/TopRug_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/MOCH_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/MOCH_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/FirstBelow1m_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/FirstBelow1m_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/FirstBelow2m_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/FirstBelow2m_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/FirstBelow5m_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/FirstBelow5m_10m.tif

gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/Below1m_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/Below1m_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/Below2m_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/Below2m_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/Below5m_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/Below5m_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p5_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p5_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p10_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p10_10m.tif

gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p25_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p25_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p50_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p50_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p75_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p75_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p90_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p90_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p95_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p95_10m.tif

gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p99_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/p99_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/MaxTime_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/MaxTime_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/MinTime_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/MinTime_10m.tif
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/DiffTime_10m.vrt /Volumes/Bitcasa2/Forestbirds/Lidar/Purg/DiffTime_10m.tif

