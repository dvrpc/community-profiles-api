from typing import List

from dotenv import load_dotenv

from schemas.data import Data
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


excluded_cols = ["state", "county", "county subdivision", "NAME"]


def build_variable_map(raw: dict[str, str]) -> dict[str, str]:
    """Expand a {code: label} dict to include MOE entries."""
    expanded: dict[str, str] = {}
    for key, variable_id in raw.items():
        expanded[key] = variable_id
        expanded[key[:-1] + "M"] = variable_id
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
    url = _build_url(variables, county_codes, state_code,
                     geo, is_subject, acs_year)
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


def transform_acs_data(raw_data,  variable_map: dict[str, str], geo_type: str):
    headers = raw_data[0]
    rows = raw_data[1:]

    if geo_type == "county":
        geo_cols = ["state", "county"]
    elif geo_type == "municipality":
        geo_cols = ["state", "county", "county subdivision"]
    else:
        raise Exception("unknown geo_type" + geo_type)

    var_map = {}
    for col in headers:
        if col in excluded_cols:
            continue
        base, suffix = col[:-1], col[-1]
        if base not in var_map:
            var_map[base] = {}
        var_map[base][suffix] = headers.index(col)

    geo_indices = {field: headers.index(field) for field in geo_cols}

    results = []
    for row in rows:
        geoid = "".join(row[geo_indices[field]] for field in geo_cols)

        for base, indices in var_map.items():
            e_idx = indices.get("E")
            m_idx = indices.get("M")

            margin_of_error = row[m_idx] if m_idx is not None else None

            if margin_of_error:
                if float(margin_of_error) < 0:
                    margin_of_error = None

            results.append({
                "geoid":            geoid,
                "variable_id":     variable_map[base + 'E'],
                "value":            row[e_idx] if e_idx is not None else None,
                "margin_of_error":  row[m_idx] if m_idx is not None else None,
            })

    return results


def _fetch_chunks(variable_map: dict[str, str], geo: str, is_subject: bool, acs_year: int):
    """Fetch all chunks for a single endpoint (detail or subject) and merge into data."""
    data = []
    for chunk in _chunk(variable_map):
        pa_raw = _fetch(chunk, PA_FIPS_FORMATTED, 42,
                        geo, is_subject, acs_year)
        nj_raw = _fetch(chunk, NJ_FIPS_FORMATTED, 34,
                        geo, is_subject, acs_year)

        data.extend(transform_acs_data(pa_raw, variable_map, geo))
        data.extend(transform_acs_data(nj_raw, variable_map, geo))

    return data


def fetch_acs_data(variable_map: dict[str, str], geo: str, acs_year: int = 2024) -> List[Data]:
    detail, subject = _split_by_endpoint(variable_map)

    log.info(
        "Fetching %d ACS variable(s) (%d detail, %d subject) for %s %d...",
        len(variable_map), len(detail), len(subject), geo, acs_year,
    )

    data = []

    if detail:
        data.extend(_fetch_chunks(detail, geo, False, acs_year))
    if subject:
        data.extend(_fetch_chunks(subject, geo, True, acs_year))

    log.info("Retrieved %d variable(s) and %d %s data rows.",
             len(variable_map), len(data), geo)
    return data
