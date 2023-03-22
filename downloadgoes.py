import GOES
import xarray as xr
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import cartopy.crs as ccrs
import numpy as np
import cartopy.feature as cf

#Download images with GOES package
files = GOES.download(Satellite='goes16', Product='ABI-L2-DMWVF',
                     DateTimeIni="20221030-200000", DateTimeFin="20221201-000000",
                     path_out='data/GOES/ABI-L2-DMWVF/', rename_fmt='%Y%m%dT%H%M')

files = GOES.download(Satellite='goes16', Product='ABI-L2-SSTF',
                     DateTimeIni="20221030-200000", DateTimeFin="20221201-000000",
                     path_out='data/GOES/ABI-L2-SSTF/', rename_fmt='%Y%m%dT%H%M')


files = GOES.download(Satellite='goes16', Product='ABI-L2-ACHAF',
                      DateTimeIni="20221030-200000", DateTimeFin="20221201-000000",
                      path_out='data/GOES/ABI-L2-ACHAF/', rename_fmt='%Y%m%dT%H%M')


# for f in files:
#     print('Processing: ', f)
#     #Open downloaded image and shrink domain
#     data               = xr.open_dataset(f)
#     x_attrs = data.x.attrs
#     y_attrs = data.y.attrs

#     x_attrs.pop('units')
#     y_attrs.pop('units')

#     data_attrs = data.attrs
#     HT_attrs   = data.HT.attrs
#     del data

#     ds                 = GOES.open_dataset(f)
#     domain             = [-90,-65,-50,-15]
#     HT, LonCen, LatCen = ds.image('HT', lonlat='corner', domain=domain)

#     lon,lat = LonCen.data, LatCen.data
#     lon = np.diff(lon[1:,:])/2+lon[1:,1:]
#     lat = np.diff(lat[1:,:])/2+lat[1:,1:]
#     lon_attrs = {'units':'degrees_east','long_name':'Longitude of center of pixels','standard_name':'pixel center longitude'}
#     lat_attrs = {'units':'degrees_north','long_name':'Latitude of center of pixels','standard_name':'pixel center latitude'}

#     data = xr.Dataset(coords={'y':np.arange(lat.shape[0]), 'x':np.arange(lon.shape[1])})
#     data.coords['lat'] = (('y','x'), lat)
#     data.coords['lon'] = (('y','x'), lon)
#     data['HT'] = (('y','x'), HT.data)

#     data.lon.attrs = lon_attrs
#     data.lat.attrs = lat_attrs
#     data.x.attrs = x_attrs
#     data.y.attrs = y_attrs
#     data.HT.attrs=HT_attrs
#     data.attrs = data_attrs
#     data.to_netcdf(f.replace('.nc','_SUBSAMPLE.nc'))
