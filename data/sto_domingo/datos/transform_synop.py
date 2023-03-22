from glob import glob
import pandas as pd
import datetime
import numpy as np
import os


def precipitation_report(synop):
    synop = str(synop)
    if 'NIL' in str(synop):
        return np.nan
    
    if synop[0] == 2: 
        rainyday = True
    elif synop[0] == 3:
        rainyday = False
    elif synop[0] == 4:
        rainyday = np.nan
    else:
        rainyday = np.nan
    return rainyday
    
def basecloud_report(synop):
    synop = str(synop)
    if 'NIL' in str(synop):
        return np.nan
    table={'0':0,
           '1':50,
           '2':100,
           '3':200,
           '4':300,
           '5':600,
           '6':1000,
           '7':1500,
           '8':2000,
           '9':2500,
           '/':np.nan}
    return table[synop[2]]

def cloudcover_report(synop):
    synop = str(synop)
    if 'NIL' in str(synop):
        return np.nan
    if synop[0] == '/':
        return np.nan
    else:
        return synop[0]

def winddirection_report(synop):
    synop = str(synop)
    if 'NIL' in str(synop):
        return np.nan
    if 'an' in synop:
        return np.nan
    if synop[1] == '/' or synop[2] == '/':
        return np.nan
    else:
        return float(synop[1]+synop[2])*10

def windspeed_report(synop):
    synop = str(synop)
    if 'an' in synop:
        return np.nan
    if 'NIL' in str(synop):
        return np.nan
    if synop[1] == '/' or synop[2] == '/':
        return np.nan
    else:
        return float(synop[3]+synop[4])*1.94

def temperature_report(synop):
    synop = str(synop)
    if 'NIL' in str(synop):
        return np.nan
    synop = str(synop)
    if synop[0] == '1' or synop[0] == '2':
        sign = synop[1]
        if sign==0:
            sign = 1
        if sign==1:
            sign = -1
        try:
            return float(synop[2]+synop[3])+float(synop[4])/10
        except:
            return np.nan
    else:
        return np.nan
    
def pressure_report(synop):

    synop = str(synop)
    if 'an' in synop:
        return np.nan
    if 'NIL' in str(synop):
        return np.nan
    synop = str(synop)
    if '=' in synop:
        return np.nan
    if '/' in synop:
        return np.nan
    if synop[0] == '3' or synop[0] == '4':
        return float('1'+synop[1]+synop[2]+synop[3])+float(synop[4])/10
    else:
        return np.nan

wd = './'
os.chdir(wd)
outname = 'stodomingo'
files = sorted(glob(wd+'synop*.csv'))
for f in files:
    print(f)
    
    os.system("cat "+f+" | awk -F '\ ' '{ print $1 }'  > 1.tmp")
    os.system("cat "+f+" | awk -F '\ ' '{ print $4 }'  > 2.tmp")
    os.system("cat "+f+" | awk -F '\ ' '{ print $5 }'  > 3.tmp")
    os.system("cat "+f+" | awk -F '\ ' '{ print $6 }'  > 4.tmp")
    os.system("cat "+f+" | awk -F '\ ' '{ print $7 }'  > 5.tmp")
    os.system("cat "+f+" | awk -F '\ ' '{ print $8 }'  > 6.tmp")
    os.system("paste -d ',' *.tmp > file.tmp")
    data = pd.read_csv('file.tmp', header=None, dtype=str)

    time = [datetime.datetime(year=int(yr), 
                              month=int(m),
                              day=int(d),
                              hour=int(h),
                              minute=int(mm)) for yr,m,d,h,mm in zip(data[1],
                                                                data[2],
                                                                data[3],
                                                                data[4],
                                                                data[5])]
    data.index = pd.to_datetime(time)
    data       = data.iloc[:,7:]
    

    rainyday   = []
    basecloud  = []
    cloudcover = []
    windir     = []
    windspeed  = []
    temp       = []
    dewpoint   = []

    for i in range(len(data)):
        # print(data.iloc[i].T)
        rainyday.append(precipitation_report(data[7][i]))
        basecloud.append(basecloud_report(data[7][i]))
        cloudcover.append(cloudcover_report(data[8][i]))
        windir.append(winddirection_report(data[8][i]))
        windspeed.append(windspeed_report(data[8][i]))    
        temp.append(temperature_report(data[9][i]))
        dewpoint.append(temperature_report(data[10][i]))
        
    cloudcover = np.array(cloudcover)
    cloudcover = list(np.where(cloudcover=='n',np.nan,cloudcover))
    data2 = pd.DataFrame([rainyday, basecloud, cloudcover, windir, windspeed, temp, dewpoint],
                         columns=data.index,
                         index=['rainyday', 'basecloud','cloudcover','winddir','windspeed','temp','dewpoint']).T
    

    data2 = data2.astype(float)
    data2.to_csv((wd+outname+'_'+f.split("_")[-1]))

    os.system('rm *.tmp')