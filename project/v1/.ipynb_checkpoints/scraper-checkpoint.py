"""
This script scrapes data about Belgian railway lines from Wikipedia, extracting information into CSV files.

Key Features:
- **Wikipedia Data Extraction:** Collects data from tables on Wikipedia pages about Belgian railway lines.
- **Dynamic URL Handling:** Extracts and processes multiple URLs of railway lines from a main Wikipedia list.
- **Data Cleaning and Saving:** Filters and formats the scraped data before saving it as CSV files.

Functions:
- **get_lijnnummer_urls:** Retrieves URLs of individual railway line pages from the main Wikipedia list.
- **scrape_lijnnummer:** Processes each railway line page and extracts relevant data.
- **scrape_table:** Parses and cleans data from the HTML table and writes it to a CSV file.

Outputs:
- Saves cleaned data into individual CSV files within the 'csv_number' directory.
"""


import requests
from bs4 import BeautifulSoup
import csv

# Function to scrape data from the table
def scrape_table(table, number):  # Adjust the selector if needed
    number = number.replace('/', '_')
    # Open a CSV file to save the data
    with open(f'csv_number/output{number}.csv', mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(['sp-km', 'sp-tekst-r', 'line_number'])

        # Loop over all rows in the table
        if table:
            for row in table.find_all('tr'):
                sp_km_td = row.find('td', class_='sp-km')
                sp_tekst_r_td = row.find('td', class_='sp-tekst-r')

                # Check if the 'sp-km' td has text and is a float
                if sp_km_td and sp_km_td.get_text().strip():
                    sp_km_text = sp_km_td.get_text().strip().split('\n')[0]
                    try:
                        sp_km_float = float(sp_km_text.replace(',', '.'))
                        print(f"Valid sp-km: {sp_km_float}")  # Debug print
                    except ValueError:
                        print(f"Invalid sp-km: {sp_km_text}")  # Debug print
                        continue  # Skip this entry if sp_km_text is not a float

                    # Clean up sp-tekst-r text
                    sp_tekst_r_text = sp_tekst_r_td.get_text().strip() if sp_tekst_r_td else ''
                    if sp_tekst_r_text.startswith('Y '):
                        sp_tekst_r_text = sp_tekst_r_text[2:]
                    sp_tekst_r_text = sp_tekst_r_text.replace('1 1 1 1 1 1', '')#split()[0] if sp_tekst_r_text else ''
                    if not ("van" in sp_tekst_r_text or "naar" in sp_tekst_r_text or "lijn" in sp_tekst_r_text):
                    # Only write the row if sp_tekst_r_text is not empty
                        if sp_tekst_r_text:
                            print(f"Writing row: {sp_km_float}, {sp_tekst_r_text}, {number}")  # Debug print
                            writer.writerow([sp_km_float, sp_tekst_r_text, number])
                    else:
                        print(f"Empty sp-tekst-r text: {sp_km_float}")  # Debug print

# Function to get 'lijnnummer' URLs from Wikipedia page
def get_lijnnummer_urls(wikipedia_url):
    response = requests.get(wikipedia_url)
    soup = BeautifulSoup(response.content, 'html.parser')

    # Find all 'td' elements containing 'href' links
    td_elements = soup.find_all('td')
    lijnnummer_urls = []

    for td in td_elements:
        a_tag = td.find('a', href=True)
        if a_tag:
            href = a_tag['href']
            if href.startswith('/wiki/Spoorlijn'):
                full_url = 'https://nl.wikipedia.org' + href
                lijnnummer_urls.append(full_url)

    return lijnnummer_urls

# Function to scrape data for each 'lijnnummer'
def scrape_lijnnummer(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.content, 'html.parser')
    if soup.findAll(text="in gebruik"):  
        nummer = url.split('_')[1]
        # Find all elements with class 'sp-km' and 'sp-tekst-r'
        table = soup.find(class_='sp-tabel')
        # Scrape the table and save the data
        scrape_table(table, nummer)

# URL of the Wikipedia page
wikipedia_url = 'https://nl.wikipedia.org/wiki/Lijst_van_spoorlijnen_in_Belgi%C3%AB'

# Get the 'lijnnummer' URLs
lijnnummer_urls = get_lijnnummer_urls(wikipedia_url)

print(lijnnummer_urls)

for url in lijnnummer_urls:
    scrape_lijnnummer(url)

print("Data scraping completed and saved to output.csv")
