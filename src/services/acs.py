from dotenv import load_dotenv
import requests 
import logging
import os

log = logging.getLogger(__name__)
load_dotenv()
CENSUS_API_KEY = os.getenv("CENSUS_API_KEY")

def fetch_acs_variable_metadata(acs_variable, data_year):
    is_subject = acs_variable[0] == 'S'
    url = f"https://api.census.gov/data/{data_year}/acs/acs5/{'subject/' if is_subject else ''}variables/{acs_variable}.json?key={CENSUS_API_KEY}"

    try:
        r = requests.get(url)
        r.raise_for_status()
        metadata = r.json()
        return metadata
    except Exception as e: 
        log.error(f"Failed to fetch {data_year} ACS metadata for {acs_variable}:", e)

