"""
This script filters CSV files to retain only rows with nodes representing Belgian railway stations that have more than 500 travelers, based on data from Wikipedia.

Key Features:
- **Wikipedia Validation:** Checks if nodes exist in a Wikipedia table of Belgian railway stations and verifies their traveler count.
- **CSV Filtering:** Reads CSV files, filters rows with valid nodes meeting the traveler threshold, and saves the results to a new directory.

Functions:
- **is_in_wikipedia_table:** Determines if a node is in the Wikipedia table and has more than 500 travelers.

Outputs:
- Filtered CSV files are saved in the 'csv_filtered' directory.
"""


import os
import pandas as pd
import requests
from bs4 import BeautifulSoup

# Function to check if a node is in the Wikipedia table and has more than 500 travelers
def is_in_wikipedia_table(node):
    url = "https://nl.wikipedia.org/wiki/Lijst_van_spoorwegstations_in_België"
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    table = soup.find('table', {'class': 'wikitable'})
    
    for row in table.find_all('tr')[1:]:
        cells = row.find_all('td')
        name = cells[0].text.strip()
        if name == node:
            try:
                travelers = int(cells[7].text.strip().replace('.', ''))  # Assuming the 8th column is the number of travelers
                return travelers > 500
            except:
                return False
    return False

# Directory containing CSV files
csv_directory = 'csvs'
filtered_directory = 'csv_filtered'

# Create filtered directory if it doesn't exist
if not os.path.exists(filtered_directory):
    os.makedirs(filtered_directory)

# Read each CSV file and update the combined graph
for file_name in os.listdir(csv_directory):
    if file_name.endswith('.csv'):
        file_path = os.path.join(csv_directory, file_name)
        
        try:
            data = pd.read_csv(file_path)
        except Exception as e:
            print(f"Error reading {file_path}: {e}")
            continue

        data['sp-tekst-r'] = data['sp-tekst-r'].str.strip()
        
        try:
            # Filter data
            filtered_data = data[data['sp-tekst-r'].apply(is_in_wikipedia_table)]

            # Save filtered data
            filtered_file_path = os.path.join(filtered_directory, file_name)
            filtered_data.to_csv(filtered_file_path, index=False)
            print(f"Filtered CSV saved as {filtered_file_path}")
        except Exception as e:
            print(f"Error processing {file_path}: {e}")

print("Filtering complete.")
