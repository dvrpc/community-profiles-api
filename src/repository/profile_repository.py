from db.database import db
import logging
import psycopg

log = logging.getLogger(__name__)

def fetch_profile(query):
    cur = db.conn.cursor()    
    response = None

    try:   
        cur.execute(query)
        data = cur.fetchone()
        column_names  = [desc[0] for desc in cur.description]
        response = dict(zip(column_names, data))
    except psycopg.OperationalError as err:
        log.error(f"Connection exception executing: \n{query} \n{err}")
    except psycopg.Error as err:
        log.error(f"Other psycopg error executing: \n{query} \n{err}")
    except Exception as err:
        log.error(f"Error executing query: \n{query} \n{err}")
    
    return response

def fetch_county(geoid):
    log.info(f'Fetching county profile: {geoid}')
    query = f"SELECT * FROM county WHERE fips = '{geoid}'"
    profile = fetch_profile(query)
    log.info(f'Succesfully retrieved county profile: {geoid}')
    return profile
    

def fetch_municipality(geoid):
    log.info(f'Fetching municipality profile: {geoid}')
    query = f"SELECT * FROM municipality WHERE geoid = '{geoid}'"
    profile = fetch_profile(query)
    log.info(f'Succesfully retrieved municipality profile: {geoid}')
    return profile