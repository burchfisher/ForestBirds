# Gdal script for mosaicing lidar tiles into regions

#Areas
#10m_DelawareValleyHD_2015
#10m_DelawareValleyHD_5A_2015
#10m_PA_3_County_South_Central_2018
#10m_PA_Northcentral_2019_B19
#10m_westernPa_1
#10m_westernPa_2
#10m_westernPa_4
#10m_pa_dauphin_2016
#10m_Lycoming_2017

echo 'NoPoints'
gdalbuildvrt -b 4 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_NoPoints_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_NoPoints_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_NoPoints_10m_pa_dauphin_2016.tif

echo 'IQR'
gdalbuildvrt -b 5 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_IQR_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_IQR_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_IQR_10m_pa_dauphin_2016.tif

echo 'VCI'
gdalbuildvrt -b 6 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_VCI_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_VCI_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_VCI_10m_pa_dauphin_2016.tif

echo 'entropy'
gdalbuildvrt -b 7 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_entropy_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_entropy_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_entropy_10m_pa_dauphin_2016.tif

echo 'FHD'
gdalbuildvrt -b 8 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_FHD_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_FHD_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_FHD_10m_pa_dauphin_2016.tif

echo 'VDR'
gdalbuildvrt -b 9 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_VDR_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_VDR_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_VDR_10m_pa_dauphin_2016.tif

echo 'top_rugosity'
gdalbuildvrt -b 10 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_top_rugosity_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_top_rugosity_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_top_rugosity_10m_pa_dauphin_2016.tif

echo 'MOCH'
gdalbuildvrt -b 11 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_MOCH_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_MOCH_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_MOCH_10m_pa_dauphin_2016.tif

echo 'skewness'
gdalbuildvrt -b 12 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_skewness_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_skewness_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_skewness_10m_pa_dauphin_2016.tif

echo 'FirstBelow1m'
gdalbuildvrt -b 13 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_FirstBelow1m_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_FirstBelow1m_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_FirstBelow1m_10m_pa_dauphin_2016.tif

echo 'FirstBelow2m'
gdalbuildvrt -b 14 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_FirstBelow2m_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_FirstBelow2m_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_FirstBelow2m_10m_pa_dauphin_2016.tif

echo 'FirstBelow5m'
gdalbuildvrt -b 15 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_FirstBelow5m_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_FirstBelow5m_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_FirstBelow5m_10m_pa_dauphin_2016.tif

echo 'Below1m'
gdalbuildvrt -b 16 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_Below1m_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_Below1m_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_Below1m_10m_pa_dauphin_2016.tif

echo 'Below2m'
gdalbuildvrt -b 17 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_Below2m_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_Below2m_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_Below2m_10m_pa_dauphin_2016.tif

echo 'Below5m'
gdalbuildvrt -b 18 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_Below5m_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_Below5m_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_Below5m_10m_pa_dauphin_2016.tif

echo 'p10'
gdalbuildvrt -b 19 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_p10_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_p10_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_p10_10m_pa_dauphin_2016.tif

echo 'p25'
gdalbuildvrt -b 20 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_p25_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_p25_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_p25_10m_pa_dauphin_2016.tif

echo 'p75'
gdalbuildvrt -b 21 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_p75_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_p75_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_p75_10m_pa_dauphin_2016.tif

echo 'p90'
gdalbuildvrt -b 22 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_p90_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_p90_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_p90_10m_pa_dauphin_2016.tif

echo 'p95'
gdalbuildvrt -b 23 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_p95_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_p95_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_p95_10m_pa_dauphin_2016.tif

echo 'SDIntensity'
gdalbuildvrt -b 24 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_SDIntensity_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_SDIntensity_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_SDIntensity_10m_pa_dauphin_2016.tif

echo 'MeanIntensity'
gdalbuildvrt -b 25 -input_file_list /nfs/forestbirds-data/10m_files_PA1.txt /nfs/forestbirds-data/TEST2/PA_lidar_MeanIntensity_10m_pa_dauphin_2016.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_lidar_MeanIntensity_10m_pa_dauphin_2016.vrt /nfs/forestbirds-data/TEST2/PA_lidar_MeanIntensity_10m_pa_dauphin_2016.tif

