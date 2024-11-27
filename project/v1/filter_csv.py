import os
import pandas as pd
import requests
from bs4 import BeautifulSoup

# Function to check if a node is in the Wikipedia table
def is_in_wikipedia_table(node):
    url = "https://nl.wikipedia.org/wiki/Lijst_van_spoorwegstations_in_België"
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    table = soup.find('table', {'class': 'wikitable'})
    nodes = [row.find_all('td')[0].text.strip() for row in table.find_all('tr')[1:]]
    return node in nodes

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
        data = pd.read_csv(file_path)
        data['sp-tekst-r'] = data['sp-tekst-r'].str.strip()
        filtered_data = data[data['sp-tekst-r'].apply(is_in_wikipedia_table)]
        filtered_file_path = os.path.join(filtered_directory, file_name)
        filtered_data.to_csv(filtered_file_path, index=False)
        print(f"Filtered CSV saved as {filtered_file_path}")

print("Filtering complete.")