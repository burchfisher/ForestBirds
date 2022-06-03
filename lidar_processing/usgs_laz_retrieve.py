# Script for bulk retrieval of LAZ files from USGS Lidar Explorer website

import urllib.request,urllib.error,http.client
import os,sys,time

################################ Inputs ############################################
file_path = '/nfs/forestbirds-data/pa_lidar/westernPa_3/western_pa3_retrieve.txt'

outdir='/nfs/forestbirds-data/pa_lidar/westernPa_3/LAZ/'


# ################################ Parse Input #####################################
f=open(file_path,'r')
linelist =f.readlines()
f.close()

print(len(linelist)," files to download")
for laz in linelist:
	words = laz.split('/')
	fname = words[-1].strip()
	# print(laz,fname)
	outpath = os.path.join(outdir,fname)
	print("downloading ",fname)
	count = 0
	while count < 5:
		if not os.path.isfile(outpath):
			try:
				urllib.request.urlretrieve(laz.strip(),outpath)
				count = 5
			except  http.client.RemoteDisconnected:
				print("http.client.RemoteDisconnected ",count)
				time.sleep(3)
				count+= 1
		else:
			print(outpath," has already been retrieved")
			count = 5
