#!/bin/bash
#SBATCH -n 1
#SBATCH -c 8

# echo 'Luzerne'
# find /nfs/forestbirds-data/processed/Luzerne_2018/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
# gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/Luzerne.vrt
# gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/Luzerne.vrt /nfs/forestbirds-data/TEST2/Luzerne.tif

# echo 'NC1'
# find /nfs/forestbirds-data/processed/Northcentral_B1/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
# gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/Northcentral_B1.vrt
# gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/Northcentral_B1.vrt /nfs/forestbirds-data/TEST2/Northcentral_B1.tif
# 
# echo 'NC2'
# find /nfs/forestbirds-data/processed/Northcentral_B2/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
# gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/Northcentral_B2.vrt
# gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/Northcentral_B2.vrt /nfs/forestbirds-data/TEST2/Northcentral_B2.tif
# 
# echo 'NC3'
# find /nfs/forestbirds-data/processed/Northcentral_B3/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
# gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/Northcentral_B3.vrt
# gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/Northcentral_B3.vrt /nfs/forestbirds-data/TEST2/Northcentral_B3.tif
# 
# echo 'NC4'
# find /nfs/forestbirds-data/processed/Northcentral_B4/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
# gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/Northcentral_B4.vrt
# gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/Northcentral_B4.vrt /nfs/forestbirds-data/TEST2/Northcentral_B4.tif

# echo 'NC5'
# find /nfs/forestbirds-data/processed/Northcentral_B5/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
# gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/Northcentral_B5.vrt
# gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/Northcentral_B5.vrt /nfs/forestbirds-data/TEST2/Northcentral_B5.tif

# find /nfs/forestbirds-data/processed/westernPa_1/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
# gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/westernPa_1.vrt
# gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/westernPa_1.vrt /nfs/forestbirds-data/TEST2/westernPa_1.tif

# find /nfs/forestbirds-data/processed/westernPa_2/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
# gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/westernPa_2.vrt
# gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/westernPa_2.vrt /nfs/forestbirds-data/TEST2/westernPa_2.tif

find /nfs/forestbirds-data/processed/westernPa_3/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/westernPa_3.vrt
gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/westernPa_3.vrt /nfs/forestbirds-data/TEST2/westernPa_3.tif

# find /nfs/forestbirds-data/processed/westernPa_4/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
# gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/westernPa_4.vrt
# gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/westernPa_4.vrt /nfs/forestbirds-data/TEST2/westernPa_4.tif

# find /nfs/forestbirds-data/processed/DelawareValleyHD_2015/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
# gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/DelawareValleyHD_2015.vrt
# gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/DelawareValleyHD_2015.vrt /nfs/forestbirds-data/TEST2/DelawareValleyHD_2015.tif

# find /nfs/forestbirds-data/processed/PA_3_County_South_Central_2018/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
# gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/PA_3_County_South_Central_2018.vrt
# gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_3_County_South_Central_2018.vrt /nfs/forestbirds-data/TEST2/PA_3_County_South_Central_2018.tif

# echo 'PSC_B1_SW'
# # find /nfs/forestbirds-data/processed/PA_South_Central_B1_2017/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
# gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/PA_South_Central_B1_2017_SW.vrt
# gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_South_Central_B1_2017_SW.vrt /nfs/forestbirds-data/TEST2/PA_South_Central_B1_2017_SW.tif

# echo 'PSC_B2'
# find /nfs/forestbirds-data/processed/PA_South_Central_B2_2017/ -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt
# gdalbuildvrt -input_file_list /nfs/forestbirds-data/TEST2/list.txt /nfs/forestbirds-data/TEST2/PA_South_Central_B2_2017.vrt
# gdal_translate -co BIGTIFF=YES /nfs/forestbirds-data/TEST2/PA_South_Central_B2_2017.vrt /nfs/forestbirds-data/TEST2/PA_South_Central_B2_2017.tif

hostname