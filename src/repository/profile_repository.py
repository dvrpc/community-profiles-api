from fastapi_cache.decorator import cache
from db.database import db
import logging
import psycopg
import asyncio
import json
log = logging.getLogger(__name__)


def fetch_one(query):
    cur = db.conn.cursor()
    response = None

    try:
        cur.execute(query)
        data = cur.fetchone()
        column_names = [desc[0] for desc in cur.description]
        response = dict(zip(column_names, data))
    except psycopg.OperationalError as err:
        log.error(f"Connection exception executing: \n{query} \n{err}")
    except psycopg.Error as err:
        log.error(f"Other psycopg error executing: \n{query} \n{err}")
    except Exception as err:
        log.error(f"Error executing query: \n{query} \n{err}")

    return response

def fetch_many(query):
    cur = db.conn.cursor()
    response = None

    try:
        cur.execute(query)
        data = cur.fetchall()
        column_names = [desc[0] for desc in cur.description]
        
        response = []
        for row in data:
            response.append(dict(zip(column_names, row)))
    except psycopg.OperationalError as err:
        log.error(f"Connection exception executing: \n{query} \n{err}")
    except psycopg.Error as err:
        log.error(f"Other psycopg error executing: \n{query} \n{err}")
    except Exception as err:
        log.error(f"Error executing query: \n{query} \n{err}")

    return response


@cache(expire=60)
async def fetch_county(geoid):
    log.info(f'Fetching county profile: {geoid}')
    query = f"SELECT * FROM county WHERE geoid = '{geoid}'"
    profile = fetch_one(query)
    log.info(f'Succesfully retrieved county profile: {geoid}')
    return profile


@cache(expire=60)
async def fetch_municipality(geoid):
    log.info(f'Fetching municipality profile: {geoid}')
    query = f"SELECT * FROM municipality WHERE geoid = '{geoid}'"
    profile = fetch_one(query)
    log.info(f'Succesfully retrieved municipality profile: {geoid}')
    return profile

@cache(expire=60)
async def fetch_region():
    log.info(f'Fetching regional profile')
    query = "SELECT * FROM region"
    profile = fetch_one(query)
    log.info(f'Succesfully retrieved regional profile')
    return profile

@cache(expire=60)
async def fetch_content(geo_level):
    log.info(f'Fetching {geo_level} content...')
    query = f"SELECT category, subcategory, name, file FROM content WHERE geo_level = '{geo_level}'"
    response = fetch_many(query)
    log.info(f'Succesfully retrieved {geo_level} content')
    return response


@cache(expire=60)
async def fetch_visualizations(geo_level, category, subcategory, topic):
    log.info(f'Fetching {geo_level}/{category}/{subcategory}/{topic} visualizations...')
    query = f"""SELECT file FROM visualizations WHERE 
                geo_level = '{geo_level}' 
                AND category = '{category}' 
                AND subcategory = '{subcategory}' 
                AND name = '{topic}' """
                
    response = fetch_one(query)
    log.info(f'Succesfully retrieved {geo_level}/{category}/{subcategory}/{topic} visualizations')
    return json.loads(response['file'])

async def fetch_content_template(geo_level: str, category: str, subcategory: str, topic: str):
    log.info(f'Fetching {geo_level}/{category}/{subcategory}/{topic} content template...')
    query = f"""SELECT file FROM content WHERE 
            geo_level = '{geo_level}' 
            AND category = '{category}' 
            AND subcategory = '{subcategory}' 
            AND name = '{topic}' """
            
    response = fetch_one(query)
    log.info(f'Succesfully retrieved {geo_level}/{category}/{subcategory}/{topic} content template...')
    return response['file']

async def fetch_viz_template(geo_level: str, category: str, subcategory: str, topic: str):
    log.info(f'Fetching {geo_level}/{category}/{subcategory}/{topic} viz template...')
    query = f"""SELECT file FROM visualizations WHERE 
            geo_level = '{geo_level}' 
            AND category = '{category}' 
            AND subcategory = '{subcategory}' 
            AND name = '{topic}' """
            
    response = fetch_one(query)
    log.info(f'Succesfully retrieved {geo_level}/{category}/{subcategory}/{topic} viz template...')
    return json.loads(response['file'])

async def fetch_template_tree(geo_level: str):
    query = f"select category, subcategory, name from content where geo_level = '{geo_level}'"
    response = fetch_many(query)
    return response