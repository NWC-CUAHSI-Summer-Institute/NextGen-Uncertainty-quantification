## NextGen-Uncertainty-quantification
This repository is crtetaed by Ngen-Uncertainty quantification group for NWC summer institute Our research topic is:Probabilistic Streamflow Prediction Using the Model-Agnostic NextGen Framework.


# Tutorial to Run ngen-cal

The first step in running ngen-cal is to install ngen in your directory.

Pull the source code from GitHub
```sh
git clone https://github.com/noaa-owp/ngen-cal
cd ngen-cal
```
Use the following command to build the ngen in your directory
```sh
./build_ngen
```
All the necessary modules should be loaded.
If there is an error about a module you can install it in your directory and use export command in the build_ngen code as there are some examples in the code. 
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
To make sure that your installed ngen works correctly you can use the following command.

```sh
 /home-directory/ngen/cmake_build/ngen /home-directory/ngen/ubiquitous-doodle/Gage_11480390.gpkg "all" /home-directory/ngen/ubiquitous-doodle/Gage_11480390.gpkg "all" realization.json
```


## ngen-cal
You can use the ngen virtual environment to setup the calibration workflow.
To do this use this command:

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
The example of realization, config, and routing .json files exist in this repository.

Pull the following reposity to make config and focrcing files using available codes for the catchments in your selected basin.

```sh
https://github.com/hellkite500/ubiquitous-doodle.git
cd /ubiquitous-doodle
```
Run this command to provide config and forcing files
```sh
AWS_NO_SIGN_REQUEST=yes python ./gen_init_config.py
```







