import logging
import math
import numpy as np
import pandas as pd
from repository.variable_repository import find_non_aggregateable_variables
from db.database import db
import asyncio

log = logging.getLogger(__name__)

excluded_variables = {
    "geoid",
    "state",
    "county",
    "co_name",
    "buffer_bbox"
}


hh_median_income_range_data = [
    {"range_start": 0, "range_end": 9999, "variable": "hh_inc_10k"},
    {"range_start": 10000, "range_end": 14999, "variable": "hh_inc_10k_15k"},
    {"range_start": 15000, "range_end": 19999, "variable": "hh_inc_15k_20k"},
    {"range_start": 20000, "range_end": 24999, "variable": "hh_inc_20k_25k"},
    {"range_start": 25000, "range_end": 29999, "variable": "hh_inc_25k_30k"},
    {"range_start": 30000, "range_end": 34999, "variable": "hh_inc_30k_35k"},
    {"range_start": 35000, "range_end": 39999, "variable": "hh_inc_35k_40k"},
    {"range_start": 40000, "range_end": 44999, "variable": "hh_inc_40k_45k"},
    {"range_start": 45000, "range_end": 49999, "variable": "hh_inc_45k_50k"},
    {"range_start": 50000, "range_end": 59999, "variable": "hh_inc_50k_60k"},
    {"range_start": 60000, "range_end": 74999, "variable": "hh_inc_60k_75k"},
    {"range_start": 75000, "range_end": 99999, "variable": "hh_inc_75k_100k"},
    {"range_start": 100000, "range_end": 124999, "variable": "hh_inc_100k_125k"},
    {"range_start": 125000, "range_end": 149999, "variable": "hh_inc_125k_150k"},
    {"range_start": 150000, "range_end": 199999, "variable": "hh_inc_150k_200k"},
    {"range_start": 200000, "range_end": None, "variable": "hh_inc_200k"}
]

fam_median_income_range_data = [
    {"range_start": 0, "range_end": 9999, "variable": "fam_inc_10k"},
    {"range_start": 10000, "range_end": 14999, "variable": "fam_inc_10k_15k"},
    {"range_start": 15000, "range_end": 19999, "variable": "fam_inc_15k_20k"},
    {"range_start": 20000, "range_end": 24999, "variable": "fam_inc_20k_25k"},
    {"range_start": 25000, "range_end": 29999, "variable": "fam_inc_25k_30k"},
    {"range_start": 30000, "range_end": 34999, "variable": "fam_inc_30k_35k"},
    {"range_start": 35000, "range_end": 39999, "variable": "fam_inc_35k_40k"},
    {"range_start": 40000, "range_end": 44999, "variable": "fam_inc_40k_45k"},
    {"range_start": 45000, "range_end": 49999, "variable": "fam_inc_45k_50k"},
    {"range_start": 50000, "range_end": 59999, "variable": "fam_inc_50k_60k"},
    {"range_start": 60000, "range_end": 74999, "variable": "fam_inc_60k_75k"},
    {"range_start": 75000, "range_end": 99999, "variable": "fam_inc_75k_100k"},
    {"range_start": 100000, "range_end": 124999, "variable": "fam_inc_100k_125k"},
    {"range_start": 125000, "range_end": 149999, "variable": "fam_inc_125k_150k"},
    {"range_start": 150000, "range_end": 199999, "variable": "fam_inc_150k_200k"},
    {"range_start": 200000, "range_end": None, "variable": "fam_inc_200k"}
]

median_age_range_data = [
    {"range_start": 0, "range_end": 4, "variable": "under_5_pop"},
    {"range_start": 5, "range_end": 9, "variable": "age_5_to_9_pop"},
    {"range_start": 10, "range_end": 14, "variable": "age_10_to_14_pop"},
    {"range_start": 15, "range_end": 19, "variable": "age_15_to_19_pop"},
    {"range_start": 20, "range_end": 24, "variable": "age_20_to_24_pop"},
    {"range_start": 25, "range_end": 29, "variable": "age_25_to_29_pop"},
    {"range_start": 30, "range_end": 34, "variable": "age_30_to_34_pop"},
    {"range_start": 35, "range_end": 39, "variable": "age_35_to_39_pop"},
    {"range_start": 40, "range_end": 44, "variable": "age_40_to_44_pop"},
    {"range_start": 45, "range_end": 49, "variable": "age_45_to_49_pop"},
    {"range_start": 50, "range_end": 54, "variable": "age_50_to_54_pop"},
    {"range_start": 55, "range_end": 59, "variable": "age_55_to_59_pop"},
    {"range_start": 60, "range_end": 64, "variable": "age_60_to_64_pop"},
    {"range_start": 65, "range_end": 69, "variable": "age_65_to_69_pop"},
    {"range_start": 70, "range_end": 74, "variable": "age_70_to_74_pop"},
    {"range_start": 75, "range_end": 79, "variable": "age_75_to_79_pop"},
    {"range_start": 80, "range_end": 84, "variable": "age_80_to_84_pop"},
    {"range_start": 85, "range_end": None, "variable": "age_85_over_pop"}
]


def aggregate_moe(column):
    return np.sqrt((column**2).sum())


async def aggregate_data(county_data: pd.DataFrame):
    aggregate_data = {}
    non_agg_vars = await find_non_aggregateable_variables()
    non_agg_vars = {v['name'] for v in non_agg_vars}

    regional_vars = await find_variables_by_geo_level('region')
    regional_vars = {v['name'] for v in regional_vars}

    # async def add_variables(recalculated_data, variable):
    #     nonlocal aggregate_data
    #     aggregate_data[variable] = recalculated_data['estimate']
    #     aggregate_data[variable + '_moe'] = recalculated_data['moe']

    # compute median and means (these call async DB helpers)
    # med_hh = await recalcute_median(hh_median_income_range_data, 1.5)
    # await add_variables(med_hh, 'median_hh_inc')
    # med_age = await recalcute_median(median_age_range_data, 1)
    # await add_variables(med_age, 'median_age')
    # med_fam = await recalcute_median(fam_median_income_range_data, 1.5)
    # await add_variables(med_fam, 'median_family_inc')
    # per_cap = await recalculate_mean("per_cap_inc", "total_pop",
    #               "per capita income")
    # await add_variables(per_cap, 'per_cap_inc')
    # mean_fam = await recalculate_mean("mean_family_inc", "total_fam",
    #                                "mean family income")
    # await add_variables(mean_fam, 'mean_family_inc')
    # mean_family_size = await recalculate_mean("mean_family_size",
    #               "total_fam", "mean family size")
    # await add_variables(mean_family_size, 'mean_family_size')
    # mean_hh_size = await recalculate_mean("mean_hh_size",
    #               "total_hh", "mean household size")
    # await add_variables(mean_hh_size, 'mean_hh_size')

    # this could be done directly in sql

    # regional_ev_data = await asyncio.to_thread(fetch_datastore,
    #     'electric_vehicle', 'regional')
    # pop_emp_regional_data = await asyncio.to_thread(fetch_sql,
    #     'pop_emp_forecasts', 'regional')

    for variable in list(county_data.columns):
        if variable not in excluded_variables | non_agg_vars:

            if "_moe" in variable:
                if variable[:-4] in regional_vars:
                    if (not (county_data[variable] == -555555555).any()):
                        aggregate_data[variable] = aggregate_moe(
                            county_data[variable])
                    else:
                        aggregate_data[variable] = None
            else:
                if variable in regional_vars:
                    aggregate_data[variable] = county_data[variable].sum()

    df = pd.DataFrame([aggregate_data])
    # df.update(regional_ev_data)
    # df.update(pop_emp_regional_data)
    return df


async def get_profile_data(query, desc):
    log.info(f'Getting {desc}...')
    try:
        async with db.pool.connection() as conn:
            async with conn.cursor() as cur:
                await cur.execute(query)
                rows = await cur.fetchall()
                columns = [desc[0] for desc in cur.description]
                df = pd.DataFrame(rows, columns=columns)

                log.info(f'Successfully fetched {desc}')
                return df
    except Exception as e:
        log.error(f'Error fetching {desc}: {e}')
        return pd.DataFrame()


async def recalcute_median(range_data, design_factor=1.5):
    variables = [range['variable'] for range in range_data]

    formatted_variables = []
    for v in variables:
        formatted_variables.append(f"SUM({v}) AS {v}")

    comma_seperated_sums = ", ".join(formatted_variables)
    query = f"SELECT {comma_seperated_sums} FROM county"

    result = await get_profile_data(query, "median range data")
    melted = result.melt(var_name="variable", value_name="count")
    range_df = pd.DataFrame(range_data)

    df = melted.merge(range_df, on="variable", how="left")
    return median_from_bins(
        df['count'], df['range_start'], df['range_end'], design_factor)


def se_to_moe90(se):
    """Convert standard error to 90% margin of error."""
    return 1.645 * se


def median_from_bins(counts, lower, upper, DF=1.5):
    """    
    Parameters
    ----------
    counts : list or array-like
        Bin counts for each range.
    lower : list or array-like
        Lower bounds of bins.
    upper : list or array-like
        Upper bounds of bins (can be np.inf for open-ended top range).
    DF : float, optional
        Design factor (default 1.5 for income).

    Returns
    -------
    dict with keys:
        'estimate' : median estimate
        'moe90'    : 90% margin of error
    """

    counts = np.array(counts, dtype=float)
    lower = np.array(lower, dtype=float)
    upper = np.array(upper, dtype=float)

    # Input validation
    if not (len(counts) == len(lower) == len(upper)):
        raise ValueError("counts, lower, and upper must have same length")

    B = np.nansum(counts)
    if B == 0:
        return {"estimate": np.nan, "moe90": np.nan}

    # Step 1: cumulative counts and percents
    cum_ct = np.cumsum(counts)
    cum_pc = 100 * cum_ct / B

    # Step 2: mid-rank (half the total)
    mid_rank = B / 2.0

    # Step 3: find bin containing the median
    b = np.argmax(cum_ct >= mid_rank)
    Lb = lower[b]
    Ub = upper[b]
    width = (Ub - Lb + 1) if np.isfinite(Ub) else np.nan

    cum_below = 0 if b == 0 else cum_ct[b - 1]
    needed = mid_rank - cum_below
    prop_in_b = needed / counts[b] if counts[b] > 0 else np.nan

    # Step 4: median estimate
    med_est = np.nan if np.isnan(width) else (Lb + prop_in_b * width)

    # Step 5: MOE steps (A–G)
    # A: SE(50%) using DF
    SE50 = DF * math.sqrt((99 / B) * (50 ** 2))
    p_low = 50 - SE50
    p_up = 50 + SE50

    # Helper: map a percentile p to value via interpolation
    def p_to_value(p):
        j_candidates = np.where(cum_pc >= p)[0]
        if len(j_candidates) == 0:
            return np.nan
        j = j_candidates[0]

        if not np.isfinite(upper[j]):  # open-ended bin
            return np.nan

        A1 = lower[j]
        A2 = lower[j + 1] if j + 1 < len(lower) else upper[j] + 1
        C1 = 0 if j == 0 else cum_pc[j - 1]
        C2 = cum_pc[j]
        frac = (p - C1) / (C2 - C1)
        return A1 + frac * (A2 - A1)

    LB = p_to_value(p_low)
    UB = p_to_value(p_up)

    # Step 6: SE(median) and MOE
    if np.isnan(LB) or np.isnan(UB):
        moe90 = np.nan
    else:
        SE_med = 0.5 * (UB - LB)
        moe90 = se_to_moe90(SE_med)

    return {"estimate": med_est, "moe": moe90}


async def recalculate_mean(numerator_var, denominator_var, desc):
    df = await get_profile_data(
        f"SELECT {denominator_var}, {numerator_var}, {numerator_var + '_moe'} FROM county", desc)

    total_denom = df[denominator_var].sum()
    agg_numer_product = df[denominator_var] * df[numerator_var]
    agg_numer_sum = agg_numer_product.sum()

    agg_product_me = df[denominator_var] * df[numerator_var + '_moe']

    agg_moe = aggregate_moe(agg_product_me)

    mean = agg_numer_sum / total_denom
    mean_moe = agg_moe / total_denom

    return {"estimate": mean, "moe": mean_moe}
