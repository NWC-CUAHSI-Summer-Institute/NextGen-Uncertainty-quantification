## NextGen-Uncertainty-quantification
This repository is crtetaed by Ngen-Uncertainty quantification group for NWC summer institute Our research topic is:Probabilistic Streamflow Prediction Using the Model-Agnostic NextGen Framework.


# Tutorial to Run ngen-cal

The first step in running ngen-cal is to install ngen in your directory.

Pull the source code from GitHub
```sh
git clone https://github.com/noaa-owp/ngen-cal
cd ngen-cal
```
Use the following code to build the ngen in your directory
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
