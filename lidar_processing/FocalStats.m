% Calculating Focal Statistics

% Go to data directory
cd ('/Volumes/Bitcasa2/Forestbirds/Lidar/PA_RTH/')

% Import the tif and its info
filename = 'p5.tif';
[A,R] = readgeoraster(filename);
info = geotiffinfo(filename);
geoTags = info.GeoTIFFTags.GeoKeyDirectoryTag;

% Set all values less than 0 to NaN and create an index of them
A(A<0) = NaN;
idx = find(isnan(A)==1);

% Run focal statistic (e.g., @nanstd) and set window size (e.g. 3x3 pixels)
Astd = colfilt(A,[3 3],'sliding',@nanstd);

% Set original pixels that had no values back to NaN
Astd(idx) = -9999.0;

% Export to geotiff
geotiffwrite('TopRug30m_MOCH_10m.tif',Astd,R,'TiffType','bigtiff', ...
                             'GeoKeyDirectoryTag',geoTags);