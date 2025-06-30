from repository.acs_resository import get_tract_data, get_muni_data, get_county_data

def build_tract_profile(geoid: int):
    # Get gis db data
    gis_data = {}
    # Get ACS data
    acs_data = get_tract_data(geoid)
    
    # Get CKAN data
    ckan_data = {}
    # Build object
    return gis_data | acs_data | ckan_data

def build_muni_profile(geoid: int):
    # Get gis db data
    gis_data = {}
    # Get ACS data
    acs_data = get_muni_data(geoid)
    
    # Get CKAN data
    ckan_data = {}
    # Build object
    return gis_data | acs_data | ckan_data


def build_county_profile(geoid: int):
    # Get gis db data
    gis_data = {}
    # Get ACS data
    acs_data = get_county_data(geoid)
    
    # Get CKAN data
    ckan_data = {}
    # Build object
    return gis_data | acs_data | ckan_data


# cur = db.conn.cursor()
# sql = """
#     SELECT mun_name, pop
#     FROM planning.pev_municipal
# """

# cur.execute(sql)
# response = cur.fetchall()