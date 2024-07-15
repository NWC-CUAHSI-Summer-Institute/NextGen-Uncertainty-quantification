import pandas as pd
import os

# Specify the directory containing the CSV files
directory = '/your desire path/'

# Initialize a list to hold dataframes
dfs = []

# Iterate over each file in the directory
for filename in os.listdir(directory):
    if filename.startswith('cat-') and filename.endswith('.csv'):
        file_path = os.path.join(directory, filename)
        df = pd.read_csv(file_path)
        dfs.append(df)

# Concatenate all dataframes
all_data = pd.concat(dfs)

# Group by 'Time' and compute the mean for each parameter
averaged_data = all_data.groupby('Time').mean().reset_index()

# Save the result to a new CSV file
averaged_data.to_csv(os.path.join(directory, 'averaged_parameters.csv'), index=False)
