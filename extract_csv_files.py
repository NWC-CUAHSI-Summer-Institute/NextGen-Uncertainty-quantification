import netCDF4 as nc
import pandas as pd

# Specify the path to your NetCDF file
nc_file_path = '11480390_2008_to_2013.nc'

# Open the NetCDF file
dataset = nc.Dataset(nc_file_path, 'r')

# Get the catchment IDs
catchment_ids = dataset.variables['ids'][:]

# Define the variables to extract
variables = ['APCP_surface', 'DLWRF_surface', 'DSWRF_surface', 'PRES_surface', 'SPFH_2maboveground', 'TMP_2maboveground', 'UGRD_10maboveground', 'VGRD_10maboveground']

# Iterate over each catchment ID and save data to a CSV file
for i, catchment_id in enumerate(catchment_ids):
    data = {}
    for var in variables:
        data[var] = dataset.variables[var][i, :]

    # Create a DataFrame
    df = pd.DataFrame(data)

    # Add the time variable to the DataFrame
    #df['Time'] = dataset.variables['Time'][i, :]
    df['Time'] = pd.to_datetime(dataset.variables['Time'][i, :],unit='s').strftime('%Y-%m-%d %H:%M:%S')
    df = df.loc[:, ['Time'] + variables]

    # Save to CSV
    df.to_csv(f'{catchment_id}.csv', index=False)

# Close the dataset
dataset.close()

