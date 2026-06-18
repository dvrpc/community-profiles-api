import repository.data_repository as data_repository
import repository.geography_repository as geo_repository


def build_profile(data):

    def clean_value(value):
        if value:
            if (value.is_integer()):
                value = int(value)
            else:
                value = round(value, 2)
        return value

    profile = {}
    for row in data:
        name = row.pop('name')
        value = clean_value(row['value'])
        margin_of_error = clean_value(row['margin_of_error'])

        profile[name] = {
            'value': value,
            'moe': margin_of_error
        }
    return profile


async def build_municipality_profile(geoid: str):
    municipality_data = await data_repository.find_by_geoid(geoid)
    county_data = await data_repository.find_by_geoid(geoid[5])
    muni_geo = await geo_repository.find_by_geoid(geoid)
    county_geo = await geo_repository.find_by_geoid(geoid[5])

    profile = build_profile(municipality_data)
    county_profile = build_profile(county_data)

    county_profile['geography'] = county_geo
    profile['geography'] = muni_geo
    profile['county'] = county_profile

    return profile


async def build_county_profile(geoid: str):
    county_data = await data_repository.find_by_geoid(geoid)
    region_data = await data_repository.find_region()
    county_geo = await geo_repository.find_by_geoid(geoid)

    profile = build_profile(county_data)
    region_profile = build_profile(region_data)

    profile['geography'] = county_geo
    profile['region'] = region_profile
    return profile


async def build_region_profile():
    region_data = await data_repository.find_region()
    profile = build_profile(region_data)
    return profile
