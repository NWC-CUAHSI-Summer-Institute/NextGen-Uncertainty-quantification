##convert nldas file to daily precipitation for further analysis
import pandas as pd

# Load the CSV file
file_path = "./your_file_name.csv"
data = pd.read_csv(file_path)

# Convert the time column to datetime format
data['time'] = pd.to_datetime(data['time'])

# Set the time column as the index
data.set_index('time', inplace=True)

# Resample the APCP_surface column to daily and calculate the average
daily_precipitation = data['APCP_surface'].resample('D').mean()

# Reset the index to get the time column back
daily_precipitation = daily_precipitation.reset_index()

# Rename the columns appropriately
daily_precipitation.columns = ['date', 'daily_precipitation']

# Save the daily precipitation data to a new CSV file
output_file_path = "daily_precipitation.csv"
daily_precipitation.to_csv(output_file_path, index=False)

# Display the head of the resulting DataFrame
daily_precipitation.head()