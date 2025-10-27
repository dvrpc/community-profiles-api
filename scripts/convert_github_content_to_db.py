
import psycopg
import requests
import os
import logging
import asyncio
import aiohttp
from dotenv import load_dotenv
from fastapi_cache.decorator import cache
import pandas as pd
from sqlalchemy import create_engine
from datetime import datetime

# from utils.consts import subcategory_map

log = logging.getLogger(__name__)

load_dotenv()
token = os.getenv("GITHUB_TOKEN")
headers = {
    "Authorization": f"Bearer {token}"
}
base_contents_url = "https://api.github.com/repos/dvrpc/community-profiles-content/contents"

subcategory_map = {
    'demographics-housing': {'demographics': [], 'housing': []},
    'economy': {'employment': [], 'income-poverty': [], 'transportation': []},
    'active-transportation': {'cycling': [], 'pedestrian': [], 'commute': []},
    'safety-health': {'crash': [], 'health': []},
    'freight': {'freight': []},
    'environment': {'open-space': [], 'planning': []},
    'transit': {'transit': [], 'tip': []},
    'roadways': {'conditions': [], 'tip': []}
}

host = os.getenv("DB_HOST")
dbname = os.getenv("DB_NAME")
user = os.getenv("DB_USER")
password = os.getenv("DB_PASS")
port = os.getenv("DB_PORT")

uri = f"postgresql://{user}:{password}@{host}:{port}/{dbname}"
print(uri)
# establish connection with the database
engine = create_engine(uri)

async def get_viz_download_url(geo_level, category, subcategory, topic):
    url = f"{base_contents_url}/{geo_level}/viz/{category}/{subcategory}/{topic}.json"
    try:
        r = requests.get(url, headers=headers)
        r.raise_for_status()

    except requests.exceptions.HTTPError as e:
        log.error(
            f"Error fetching {geo_level} contents: \n{e}")

    data =  r.json()

    return data['download_url']


async def get_download_urls(geo_level, type):
    urls = []
    
    for key, value in subcategory_map.items():
        for subcategory in value.keys():
            urls.append({
                'category': key,
                'subcategory': subcategory,
                'geo_level': geo_level,
                'url': f"{base_contents_url}/{geo_level}/{type}/{key}/{subcategory}" 
            })
    
    
    async with aiohttp.ClientSession() as session:
        tasks = []
        for url in urls:
            tasks.append(get_download_url(session, url, type))

        results = await asyncio.gather(*tasks)
        flattened = [item for sublist in results for item in sublist]
        return flattened

async def get_download_url(session, url, type):
    try:
        async with session.get(url['url'], headers=headers) as response:
            if response.status == 200:
                data = await response.json()
                download_urls = []
                for file in data:
                    index = -5 if type == 'viz' else -3
                    download_urls.append({
                        'category': url['category'],
                        'subcategory': url['subcategory'],
                        'geo_level': url['geo_level'],
                        'name': file['name'][:index],
                        'url': file['download_url'],
                    })
                return download_urls
            else:
                log.info(response.status)
    except aiohttp.ClientConnectionError as e:
        log.error(f'Connection error: {e}')
        
async def get_files(urls):
    async with aiohttp.ClientSession() as session:
        tasks = []
        for url in urls:
            tasks.append(get_file(session, url))

        results = await asyncio.gather(*tasks)
        return results


async def get_file(session, url):
    try:
        async with session.get(url['url']) as response:
            if response.status == 200:
                text = await response.text()
                return {
                    'category': url['category'],
                    'subcategory': url['subcategory'],
                    'geo_level': url['geo_level'],
                    'name': url['name'],
                    'file': text,
                }
            else:
                log.info(response.status)
    except aiohttp.ClientConnectionError as e:
        log.error(f'Connection error: {e}')


# def get_file(url):
#     try:
#         r = requests.get(url)
#         r.raise_for_status()

#     except requests.exceptions.HTTPError as e:
#         log.error(
#             f"Error fetching {url}: \n{e}")

#     return r.json()

async def save_content(geo_level):
    all_urls = []
    for geo_level in ['region', 'county', 'municipality']:
        md_download_urls = await get_download_urls(geo_level, 'md')
        all_urls += md_download_urls

    files = await get_files(all_urls)
    df = pd.DataFrame(files)
    
    current_local_time = datetime.now()
    df['create_date'] = current_local_time
    df.to_sql('content', con=engine, if_exists='replace',index=False)
    
async def save_visualizations(geo_level):
    all_urls = []

    for geo_level in ['region', 'county', 'municipality']:
        viz_download_urls = await get_download_urls(geo_level, 'viz')
        all_urls += viz_download_urls


    files = await get_files(all_urls)
    df = pd.DataFrame(files)
    
    current_local_time = datetime.now()
    df['create_date'] = current_local_time
    df.to_sql('visualizations', con=engine, if_exists='replace',index=False)
    
asyncio.run(save_content('county'))
asyncio.run(save_visualizations('county'))




# content_map = copy.deepcopy(subcategory_map)
# for md in files:
#     content_map[md['category']][md['subcategory']].append({
#         'name': md['name'],
#         'content': content
#     })

# return content_map