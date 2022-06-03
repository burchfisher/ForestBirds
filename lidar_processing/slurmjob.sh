#!/bin/bash
#SBATCH -n 1
#SBATCH -c 2

gdalbuildvrt -b 4 -input_file_list /nfs/forestbirds-data/Lycoming_list.txt /nfs/forestbirds-data/TEST2/PA_lidar_NoPoints_10m_Lycoming_Preview.vrt
gdal_translate -co BIGTIFF=YES -tr 10 10 /nfs/forestbirds-data/mosaics_EPSG_6350/PA_lidar_Below5m_10m.vrt /nfs/forestbirds-data/mosaics_EPSG_6350/PA_lidar_Below5m_10m.tif

hostname



find /nfs/forestbirds-data/processed/Northcentral_B5 -name "*.tif" > /nfs/forestbirds-data/TEST2/list.txt

gdaltindex /nfs/forestbirds-data/GIS/Tif_Tile_Index/westernPa_3_tindex.shp /nfs/forestbirds-data/processed/westernPa_3/*.tif
