#!/bin/bash

# Function to load a module and check if successful
load_module() {
    module load "$1" &>/dev/null
    if [[ $? -eq 0 ]]; then
        echo "Loaded module $1 successfully."
    else
        echo "Module $1 cannot be loaded, it might be unavailable or misspelled."
        module avail "$1"
        exit 1
    fi
}

# Load required modules
load_module GCCcore/12.2.0
load_module cmake
load_module UDUNITS/2.2.28-GCCcore-12.2.0
load_module netCDF/4.9.2

# Activate the virtual environment
source $HOME/python3.9/venv/bin/activate

# Upgrade pip and install required Python packages
pip install --upgrade pip
pip install numpy pandas scipy hydrotools  # Add other necessary packages

# Ensure the user is in the correct directory
cd "$(dirname "$0")/../ngen" || exit

# Ask user to update submodules
read -p "Update submodules (yes/no)? " update_submodules
if [[ "$update_submodules" == "yes" ]]; then
    git submodule update --init --recursive
else
    echo "Skipping submodule update."
fi

# Create build directory and configure the build
mkdir -p cmake_build
cd cmake_build || exit

# Set NetCDF paths
NETCDF_ROOT="/apps/netCDF/4.9.2-iimpi-2023a"
export CPATH="$NETCDF_ROOT/include:$CPATH"
export LIBRARY_PATH="$NETCDF_ROOT/lib:$LIBRARY_PATH"
export LD_LIBRARY_PATH="$NETCDF_ROOT/lib:$LD_LIBRARY_PATH"

# Set paths for local SQLite and Python installation
SQLITE_ROOT="$HOME/local/sqlite"
PYTHON_ROOT="$HOME/python3.9"
export PATH="$PYTHON_ROOT/bin:$SQLITE_ROOT/bin:$PATH"
export LD_LIBRARY_PATH="$PYTHON_ROOT/lib:$SQLITE_ROOT/lib:$LD_LIBRARY_PATH"
export CPATH="$SQLITE_ROOT/include:$CPATH"
export LIBRARY_PATH="$SQLITE_ROOT/lib:$LIBRARY_PATH"
export PYTHON_INCLUDE_DIR="$PYTHON_ROOT/include/python3.9"
export PYTHON_LIBRARY="$PYTHON_ROOT/lib/libpython3.9.so"
export NUMPY_INCLUDE_DIR=$("$PYTHON_ROOT/bin/python3.9" -c "import numpy; print(numpy.get_include())")

# Verify that NumPy include directory is set
if [[ -z "$NUMPY_INCLUDE_DIR" ]]; then
    echo "NumPy include directory not found. Please ensure NumPy is installed for Python 3.9."
    exit 1
fi

# Verify that SQLite3 include and library directories are set
if [[ ! -d "$SQLITE_ROOT/include" || ! -f "$SQLITE_ROOT/lib/libsqlite3.so" ]]; then
    echo "SQLite3 include or library directories not found. Please ensure SQLite3 is installed correctly."
    exit 1
fi

# Configure CMake with the correct paths including SQLite
cmake \
    -DNetCDF_ROOT=$NETCDF_ROOT \
    -DNGEN_WITH_MPI:BOOL=OFF \
    -DNGEN_WITH_NETCDF:BOOL=ON \
    -DNGEN_WITH_SQLITE:BOOL=ON \
    -DSQLite3_INCLUDE_DIR=$SQLITE_ROOT/include \
    -DSQLite3_LIBRARY=$SQLITE_ROOT/lib/libsqlite3.so \
    -DNGEN_WITH_UDUNITS:BOOL=ON \
    -DNGEN_WITH_BMI_FORTRAN:BOOL=ON \
    -DNGEN_WITH_BMI_C:BOOL=ON \
    -DNGEN_WITH_PYTHON:BOOL=ON \
    -DPYTHON_INCLUDE_DIR=$PYTHON_INCLUDE_DIR \
    -DPYTHON_LIBRARY=$PYTHON_LIBRARY \
    -DPython3_NumPy_INCLUDE_DIRS=$NUMPY_INCLUDE_DIR \
    -DNGEN_WITH_ROUTING:BOOL=ON \
    -DNGEN_WITH_TESTS:BOOL=OFF \
    -DNGEN_QUIET:BOOL=OFF \
    -S ..

# Build ngen
cmake --build . --target ngen -- -j "$(nproc)"

echo "Build completed"

# Run tests
cmake \
    -DNetCDF_ROOT=$NETCDF_ROOT \
    -DNGEN_WITH_MPI:BOOL=OFF \
    -DNGEN_WITH_NETCDF:BOOL=ON \
    -DNGEN_WITH_SQLITE:BOOL=ON \
    -DSQLite3_INCLUDE_DIR=$SQLITE_ROOT/include \
    -DSQLite3_LIBRARY=$SQLITE_ROOT/lib/libsqlite3.so \
    -DNGEN_WITH_UDUNITS:BOOL=ON \
    -DNGEN_WITH_BMI_FORTRAN:BOOL=ON \
    -DNGEN_WITH_BMI_C:BOOL=ON \
    -DNGEN_WITH_PYTHON:BOOL=ON \
    -DPYTHON_INCLUDE_DIR=$PYTHON_INCLUDE_DIR \
    -DPYTHON_LIBRARY=$PYTHON_LIBRARY \
    -DPython3_NumPy_INCLUDE_DIRS=$NUMPY_INCLUDE_DIR \
    -DNGEN_WITH_ROUTING:BOOL=ON \
    -DNGEN_WITH_TESTS:BOOL=ON \
    -DNGEN_QUIET:BOOL=OFF \
    -S ..

cmake --build . --target test_unit -- -j "$(nproc)"
./test/test_unit

echo "Testing complete"

