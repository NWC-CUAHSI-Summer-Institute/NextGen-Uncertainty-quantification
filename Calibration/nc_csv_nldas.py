#### This code extracts the data from the NetCDF file uploaded by Araki et al. (2023) on GitHub for the CUAHSI SI 2023.
import netCDF4 as nc
import pandas as pd
import numpy as np

# Open the NetCDF file
dataset = nc.Dataset('usgs-streamflow-nldas_hourly.nc')

# Get the basin IDs
basin_ids = dataset.variables['basin'][:]
print("Basin IDs:")
print(basin_ids)

# Specify the target basin ID
target_basin_id = 'your_basin_ID'  # Replace with the actual basin ID you are interested in

# Find the index of the target basin ID
target_basin_index = np.where(basin_ids == target_basin_id)[0][0]

# Get the dimensions
dimensions = dataset.dimensions
print("Dimensions:")
for dim in dimensions:
    print(dim, len(dimensions[dim]))

# Get the variables
variables = dataset.variables
print("\nVariables:")
for var in variables:
    print(var, variables[var].dimensions, variables[var].shape)

# Assuming you want to convert variables for the specific basin to CSV
for var in variables:
    if 'basin' in variables[var].dimensions and 'date' in variables[var].dimensions:
        print(f"Processing variable: {var}")
        data = dataset.variables[var][:]  # Read all data for the variable

        # Filter data for the target basin
        basin_data = data[target_basin_index, :]

        # Create a DataFrame with date and the variable
        dates = dataset.variables['date'][:]
        df = pd.DataFrame({
            'date': dates,
            var: basin_data
        })

        # Save to CSV
        df.to_csv(f'{var}_basin_{target_basin_id}.csv', index=False)
        print(f"Variable {var} saved to CSV for basin {target_basin_id}")

# Close the dataset
dataset.close()
print("Dataset closed")
