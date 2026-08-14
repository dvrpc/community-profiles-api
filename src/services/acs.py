from dotenv import load_dotenv
from datetime import date
import requests
import logging
import os

log = logging.getLogger(__name__)
load_dotenv()
CENSUS_API_KEY = os.getenv("CENSUS_API_KEY")


def get_latest_acs_year() -> int:
    for acs_year in range(date.today().year - 1, 2022, -1):
        try:
            response = requests.get(
                f"https://api.census.gov/data/{acs_year}/acs/acs5",
                params={"get": "NAME", "for": "us:1", "key": CENSUS_API_KEY},
                timeout=30,
            )
        except requests.RequestException as error:
            log.error("Failed to check ACS %s availability: %s",
                      acs_year, error)
            raise RuntimeError(
                "Could not determine the latest ACS year") from error

        if response.ok:
            return acs_year
        if response.status_code != 404:
            response.raise_for_status()

    raise RuntimeError("No ACS 5-year estimate is available.")


def fetch_acs_variable_metadata(acs_variable, data_year):
    is_subject = acs_variable[0] == 'S'
    url = f"https://api.census.gov/data/{data_year}/acs/acs5/{'subject/' if is_subject else ''}variables/{acs_variable}.json?key={CENSUS_API_KEY}"

    try:
        r = requests.get(url)
        r.raise_for_status()
        metadata = r.json()
        return metadata
    except Exception as e:
        log.error(
            f"Failed to fetch {data_year} ACS metadata for {acs_variable}:", e)
