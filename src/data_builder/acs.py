from dotenv import load_dotenv
from .consts import (
    CHUNK_SIZE, PA_FIPS, PA_FIPS_FORMATTED,
    NJ_FIPS, NJ_FIPS_FORMATTED,
    STATE_FIPS,
)
import requests
import os
import logging
import pandas as pd

log = logging.getLogger(__name__)
load_dotenv()

API_KEY = os.getenv("CENSUS_API_KEY")


def build_variable_map(raw: dict[str, str]) -> dict[str, str]:
    """Expand a {code: label} dict to include MOE entries."""
    expanded: dict[str, str] = {}
    for key, label in raw.items():
        expanded[key] = label
        expanded[key[:-1] + "M"] = label + "_moe"
    return expanded


def _split_by_endpoint(variable_map: dict[str, str]) -> tuple[dict[str, str], dict[str, str]]:
    """Split a variable map into detail and subject dicts by variable prefix."""
    detail = {k: v for k, v in variable_map.items() if not k.startswith("S")}
    subject = {k: v for k, v in variable_map.items() if k.startswith("S")}
    return detail, subject


def _chunk(variable_map: dict[str, str], chunk_size: int = CHUNK_SIZE) -> list[list[str]]:
    keys = list(variable_map.keys())
    return [keys[i:i + chunk_size] for i in range(0, len(keys), chunk_size)]



def _build_url(variables: list[str], county_codes: str, state_code: int, geo: str, is_subject: bool, acs_year: int) -> str:
    subject = "/subject" if is_subject else ""
    var_string = ",".join(variables)

    if geo == "county":
        return (
            f"https://api.census.gov/data/{acs_year}/acs/acs5{subject}"
            f"?get={var_string}&for=county:{county_codes}&in=state:{state_code}&key={API_KEY}"
        )
    return (
        f"https://api.census.gov/data/{acs_year}/acs/acs5{subject}"
        f"?get={var_string},NAME&for=county%20subdivision:*&in=county:{county_codes}&in=state:{state_code}&key={API_KEY}"
    )


def _fetch(variables: list[str], county_codes: str, state_code: int, geo: str, is_subject: bool, acs_year: int) -> list:
    url = _build_url(variables, county_codes, state_code, geo, is_subject, acs_year)
    try:
        r = requests.get(url)
        r.raise_for_status()
    except requests.exceptions.HTTPError as e:
        log.error(
            "Failed to fetch ACS %s data for state %s, counties %s: %s",
            geo, state_code, county_codes, e.response.text,
        )
        raise
    return r.json()

def _map_columns(variable_map: dict[str, str], raw_columns: list[str]) -> list[str]:
    return [variable_map.get(col, col) for col in raw_columns]


def _clean_county_df(df: pd.DataFrame, is_first: bool) -> pd.DataFrame:
    df["fips"] = df["state"] + df["county"]
    if is_first:
        df["state"] = df["state"].replace(STATE_FIPS)
        df["county"] = df["county"].replace(PA_FIPS | NJ_FIPS)
    else:
        df = df.drop(columns=["state", "county"])
    return df


def _clean_muni_df(df: pd.DataFrame, is_first: bool) -> pd.DataFrame:
    df["geoid"] = df["state"] + df["county"] + df["county subdivision"]
    if is_first:
        df["state"] = df["state"].replace(STATE_FIPS)
        df["county"] = df["county"].replace(PA_FIPS | NJ_FIPS)
        df["mun_name"] = df["NAME"].str.split(",").str[0].str.title()
        df = df.drop(columns=["NAME", "county subdivision"])
    else:
        df = df.drop(columns=["state", "county", "NAME", "county subdivision"])
    return df


def _fetch_chunks(variable_map: dict[str, str], geo: str, is_subject: bool, acs_year: int, merge_key: str, data: pd.DataFrame, is_first: bool) -> tuple[pd.DataFrame, bool]:
    """Fetch all chunks for a single endpoint (detail or subject) and merge into data."""
    for chunk in _chunk(variable_map):
        pa_raw = _fetch(chunk, PA_FIPS_FORMATTED, 42, geo, is_subject, acs_year)
        nj_raw = _fetch(chunk, NJ_FIPS_FORMATTED, 34, geo, is_subject, acs_year)

        header = _map_columns(variable_map, pa_raw[0])
        df = pd.DataFrame(pa_raw[1:] + nj_raw[1:], columns=header)

        df = _clean_county_df(df, is_first) if geo == "county" else _clean_muni_df(df, is_first)

        data = df if data.empty else data.merge(df, on=merge_key)
        is_first = False

    return data, is_first


def fetch_acs_data(variable_map: dict[str, str], geo: str, acs_year: int = 2024) -> pd.DataFrame:
    detail, subject = _split_by_endpoint(variable_map)
    merge_key = "fips" if geo == "county" else "geoid"

    log.info(
        "Fetching %d ACS variable(s) (%d detail, %d subject) for %s %d...",
        len(variable_map), len(detail), len(subject), geo, acs_year,
    )

    data = pd.DataFrame()
    is_first = True

    if detail:
        data, is_first = _fetch_chunks(detail, geo, False, acs_year, merge_key, data, is_first)
    if subject:
        data, is_first = _fetch_chunks(subject, geo, True, acs_year, merge_key, data, is_first)

    lead_cols = ["fips", "state", "county"] if geo == "county" else ["geoid", "mun_name", "county", "state"]
    data = data[lead_cols + [c for c in data.columns if c not in lead_cols]]

    log.info("Retrieved %d variable(s) for %d %s record(s).", len(variable_map), len(data), geo)
    return data


def get_county_data(variable_map: dict[str, str], acs_year: int = 2024) -> pd.DataFrame:
    """Fetch ACS county data for the provided variable map."""
    return fetch_acs_data(variable_map, "county", acs_year)


def get_muni_data(variable_map: dict[str, str], acs_year: int = 2024) -> pd.DataFrame:
    """Fetch ACS municipality data for the provided variable map."""
    return fetch_acs_data(variable_map, "muni", acs_year)
