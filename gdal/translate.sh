# GDAL script to mosaic the large areas together

echo 'Creating VRTs'
find /Volumes/Bitcasa/mosaics -name "PA_lidar_NoPoints*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_NoPoints_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_IQR*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_IQR_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_VCI*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_VCI_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_entropy*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_entropy_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_FHD*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_FHD_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_VDR*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_VDR_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_top_rugosity*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_top_rugosity_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_MOCH*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_MOCH_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_skewness*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_skewness_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_FirstBelow1m*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_FirstBelow1m_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_FirstBelow2m*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_FirstBelow2m_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_FirstBelow5m*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_FirstBelow5m_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_Below1m*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_Below1m_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_Below2m*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_Below2m_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_Below5m*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_Below5m_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_p10*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_p10_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_p25*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_p25_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_p75*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_p75_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_p90*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_p90_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_p95*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_p95_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_SDIntensity*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_SDIntensity_10m.vrt

find /Volumes/Bitcasa/mosaics -name "PA_lidar_MeanIntensity*" > list.txt
gdalbuildvrt -input_file_list /Volumes/Bitcasa/mosaics/list.txt /Volumes/Bitcasa/mosaics/PA_lidar_MeanIntensity_10m.vrt

#####################################################################################################################################################################

echo 'NoPoints'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_NoPoints_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_NoPoints_10m.tif

echo 'IQR'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_IQR_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_IQR_10m.tif

echo 'VCI'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_VCI_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_VCI_10m.tif

echo 'entropy'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_entropy_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_entropy_10m.tif

echo 'FHD'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_FHD_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_FHD_10m.tif

echo 'VDR'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_VDR_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_VDR_10m.tif

echo 'top_rugosity'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_top_rugosity_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_top_rugosity_10m.tif

echo 'MOCH'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_MOCH_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_MOCH_10m.tif

echo 'skewness'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_skewness_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_skewness_10m.tif

echo 'FirstBelow1m'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_FirstBelow1m_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_FirstBelow1m_10m.tif

echo 'FirstBelow2m'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_FirstBelow2m_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_FirstBelow2m_10m.tif

echo 'FirstBelow5m'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_FirstBelow5m_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_FirstBelow5m_10m.tif

echo 'Below1m'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_Below1m_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_Below1m_10m.tif

echo 'Below2m'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_Below2m_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_Below2m_10m.tif

echo 'Below5m'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_Below5m_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_Below5m_10m.tif

echo 'p10'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_p10_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_p10_10m.tif

echo 'p25'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_p25_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_p25_10m.tif

echo 'p75'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_p75_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_p75_10m.tif

echo 'p90'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_p90_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_p90_10m.tif

echo 'p95'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_p95_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_p95_10m.tif

echo 'SDIntensity'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_SDIntensity_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_SDIntensity_10m.tif

echo 'MeanIntensity'
gdal_translate -co BIGTIFF=YES /Volumes/Bitcasa/mosaics/PA_lidar_MeanIntensity_10m.vrt /Volumes/Bitcasa/mosaics/PA_lidar_MeanIntensity_10m.tif
