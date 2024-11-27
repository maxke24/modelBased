import os
import csv

# Directory containing CSV files
folder_path = 'csv_filtered'

# Words to look for
keywords = {"Oost", "Zuid", "Noord", "West"}

# List to store locations of entries with keywords and spaces
keyword_locations = []
space_locations = []

for file_name in os.listdir(folder_path):
    if file_name.endswith('.csv'):
        file_path = os.path.join(folder_path, file_name)
        cleaned_data = []

        # Read and clean the CSV file
        with open(file_path, 'r', encoding='utf-8') as infile:
            reader = csv.reader(infile)
            for i, row in enumerate(reader):
                cleaned_row = [cell.strip().rstrip(',') for cell in row]
                cleaned_data.append(cleaned_row)
                
                # Check for entries with the keywords
                if any(cell in keywords for cell in cleaned_row):
                    keyword_locations.append((file_name, i + 1, cleaned_row))
                
                # Check for entries with spaces
                if any(' ' in cell for cell in cleaned_row):
                    space_locations.append((file_name, i + 1, cleaned_row))

        # Write the cleaned data back to the same file
        with open(file_path, 'w', newline='', encoding='utf-8') as outfile:
            writer = csv.writer(outfile)
            writer.writerows(cleaned_data)

# Save keyword and space locations to separate files
with open('keyword_locations.csv', 'w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(['File Name', 'Row Number', 'Row Content'])
    writer.writerows(keyword_locations)

with open('space_locations.csv', 'w', newline='', encoding='utf-8') as file:
    writer = csv.writer(file)
    writer.writerow(['File Name', 'Row Number', 'Row Content'])
    writer.writerows(space_locations)

print("Data cleaning and keyword search completed. Locations saved to 'keyword_locations.csv' and 'space_locations.csv'.")
