from dotenv import load_dotenv

import requests
import os 
import logging

log = logging.getLogger(__name__)
load_dotenv()

census_variables = [
    "B01003_001E", # Total Population
    "B11001_001E", # Total Households
    "B19301_001E", # Median Income (Per Capita Income)
    "B19013_001E", # Median Household Income
    "B17001_002E", # Below poverty level
    "B01002_001E" # Median age
]

API_KEY = os.getenv("CENSUS_API_KEY")

def get_tract_data(geoid: int):
    comma_seperated_variables = ','.join(census_variables)
    url = f"https://api.census.gov/data/2023/acs/acs5?get={comma_seperated_variables}&ucgid=1400000US{geoid}&key={API_KEY}"

    try:
        r = requests.get(url)
        r.raise_for_status()
    except requests.exceptions.HTTPError as e:
        log.error(f"Failed to fetch ACS tract data for {geoid}: {e.response.text}")

    values = r.json()[1]
    
    return {
        "total_pop": values[0], 
        "total_hh": values[1], 
        "med_inc": values[2], 
        "med_inc_hh": values[3],
        "below_pov": values[4],
        "med_age": values[5],
    }


def get_muni_data(geoid: int):
    comma_seperated_variables = ','.join(census_variables)
    url = f"https://api.census.gov/data/2023/acs/acs5?get={comma_seperated_variables}&ucgid=1600000US{geoid}&key={API_KEY}"

    try:
        r = requests.get(url)
        r.raise_for_status()
    except requests.exceptions.HTTPError as e:
        log.error(f"Failed to fetch ACS muni data for {geoid}: {e.response.text}")

    values = r.json()[1]
    
    return {
        "total_pop": values[0], 
        "total_hh": values[1], 
        "med_inc": values[2], 
        "med_inc_hh": values[3],
        "below_pov": values[4],
        "med_age": values[5],
    }

def get_county_data(geoid: int):
    comma_seperated_variables = ','.join(census_variables)
    url = f"https://api.census.gov/data/2023/acs/acs5?get={comma_seperated_variables}&ucgid=0500000US{geoid}&key={API_KEY}"
    
    try:
        r = requests.get(url)
        r.raise_for_status()
    except requests.exceptions.HTTPError as e:
        log.error(f"Failed to fetch ACS county data for {geoid}: {e.response.text}")

    values = r.json()[1]
    
    return {
        "total_pop": values[0], 
        "total_hh": values[1], 
        "med_inc": values[2], 
        "med_inc_hh": values[3],
        "below_pov": values[4],
        "med_age": values[5],
    }