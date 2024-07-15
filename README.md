# NextGen-Uncertainty-quantification
This repository is created by the Ngen-Uncertainty quantification group for the NWC summer institute. Our research topic is:Probabilistic Streamflow Prediction Using the Model-Agnostic NextGen Framework.

## Study Area

Three CAMELS basins are selected in the northwest of Sacramento. These basins are chosen for their unique hydrological characteristics and the availability of comprehensive data. The selected basins are shown in the following image.

![Basins DEM](https://github.com/NWC-CUAHSI-Summer-Institute/NextGen-Uncertainty-quantification/raw/main/Basins_DEM.png)
# Tutorial to Run ngen-cal

The first step in running ngen-cal is to install ngen in your directory.

## Pull the source code from GitHub
Run the following command to clone the repository.

```sh
git clone https://github.com/NOAA-OWP/ngen.git
cd ngen
```
Use the following command to build the ngen in your directory
```sh
./build_ngen
```
All the necessary modules should be loaded.
If there is an error about a module you can install it in your directory and use export command in the build_ngen code.
There are some examples in the build_ngen code using export command. 

For example:

```sh
cd /"home directory"
wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz
tar -xzf Python-3.9.16.tgz
cd Python-3.9.16
./configure --prefix=/"home directory"/python3.9 --enable-shared
make -j "$(nproc)"
make install
```
# Testing installed ngen
To make sure that your installed ngen works correctly, you can use the following command. Supposed you have loaded the routing module in your environment.

```sh
 /home-directory/ngen/cmake_build/ngen /home-directory/ngen/ubiquitous-doodle/Gage_11480390.gpkg "all" /home-directory/ngen/ubiquitous-doodle/Gage_11480390.gpkg "all" realization.json
```


# ngen-cal
You can use the ngen virtual environment to set up the calibration workflow.
To do this, use this command:

```sh
python -m venv venv
source ./venv/bin/activate
```
Now, pull the ngen-cal repository to your directory:

```sh
https://github.com/NOAA-OWP/ngen-cal/wiki/Installing-ngen-cal
```
Use the following command to install required package for calibration

```sh
pip install -e python/ngen_cal
pip install python/ngen_config_gen
cd ..
```
To get the hydrofabric geopackage use can use the following command. 

```sh
wget http://lynker-spatial.s3.amazonaws.com/hydrofabric/v20.1/camels/Gage_11480390.gpkg
```
The example of realization, config, and routing files exist in this repository.

Pull the following repository to make config files using available codes for the catchments in your selected basin.

```sh
git clone https://github.com/hellkite500/ubiquitous-doodle.git
cd /ubiquitous-doodle
```

Run this command to provide config and forcing files:

```sh
AWS_NO_SIGN_REQUEST=yes python ./gen_init_config.py
```

To get some forcing data pull the following reposity:
```sh
git clone https://github.com/jmframe/CIROH_DL_NextGen
```
Use the forcing file.yaml example in this repo.

Run the folloiwng command to get the forcing files for all the catchments within the basin:

```sh
pip install -r CIROH_DL_NextGen/forcing_prep/requirements.txt
python CIROH_DL_NextGen/forcing_prep/generate.py forcing.yaml
```
You will get the netCDF forcing files for the catchments. You need to run the following command to extract csv forcing files.
The code is available in this directory

```sh
cd /forcing
python extract_csv_files.py
```
Now you need the routing module to run the ngen-cal. 


# Install Required Python Modules and Routing Module

Run the following commands to install the required Python modules and the routing module:

```sh
# Install required Python modules
pip3 install numpy pandas xarray netcdf4 joblib toolz pyyaml Cython>3,!=3.0.4 geopandas pyarrow deprecated wheel
```
## Clone t-route
```sh
git clone --progress --single-branch --branch master http://github.com/NOAA-OWP/t-route.git
cd t-route
```
## Compile and install
```sh
./compiler.sh
```
## In the event that compilation results do not complete and throws a Cython compile error, rerun with a non-editable flag:
```sh
./compiler.sh no-e
```
# Running ngen-cal
Now evertything is ready, and you can run the following command to calibrate the model:

```sh
python -m ngen.cal config.yaml
```




