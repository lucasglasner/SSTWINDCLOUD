## Notes for installing and using GOES2GO python package.
---

1) wget https://raw.githubusercontent.com/blaylockbk/goes2go/main/environment.yml \
   mv enviroment.yml goes2go.yml \
   Then install the conda enviroment with: \
   conda env create -f goes2go.yml \

   This will create a conda enviroment with the requiered dependencies.   \
   For using the package just open the shell and run "conda activate goes2go"  

2) With the package installed, it was needed to change the output directory of downloaded files. \
   For this, edit the text file ~/.config/goes2go/config.toml and change the save directory.

3) For downloading historical data it can be used the next method in a python3 shell: 

   %%python3 \
   from goes2go import GOES \
   G = GOES(satellite=16, product="ABI-L2-ACHAF", domain='F') \
   \# Download data for a specified time range \
   G.timerange(start='2022-06-01 00:00', end='2022-06-01 01:00')  

   ---

   ## Notes for installing and using GOES python package (other)

   1) pip3 install GOES
