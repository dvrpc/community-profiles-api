import requests
import os
import logging
import asyncio
import aiohttp
from dotenv import load_dotenv
from fastapi_cache.decorator import cache
from utils.consts import subcategory_map

log = logging.getLogger(__name__)

load_dotenv()
token = os.getenv("GITHUB_TOKEN")
headers = {
    "Authorization": f"Bearer {token}"
}
base_contents_url = "https://api.github.com/repos/dvrpc/community-profiles-content/contents"

# https://raw.githubusercontent.com/{owner}/{repo}/{branch}/README.md


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


@cache(expire=60)
async def get_md_download_urls(geo_level):
    urls = []
    
    for key, value in subcategory_map.items():
        for subcategory in value.keys():
            urls.append({
                'category': key,
                'subcategory': subcategory,
                'url': f"{base_contents_url}/{geo_level}/md/{key}/{subcategory}" 
            })
    
    
    async with aiohttp.ClientSession() as session:
        tasks = []
        for url in urls:
            tasks.append(get_md_download_url(session, url))

        results = await asyncio.gather(*tasks)
        flattened = [item for sublist in results for item in sublist]
        return flattened

async def get_md_download_url(session, url):
    try:
        async with session.get(url['url'], headers=headers) as response:
            if response.status == 200:
                data = await response.json()
                download_urls = []
                for file in data:
                    download_urls.append({
                        'category': url['category'],
                        'subcategory': url['subcategory'],
                        'name': file['name'][:-3],
                        'url': file['download_url'],
                    })
                return download_urls
            else:
                log.info(response.status)
    except aiohttp.ClientConnectionError as e:
        log.error(f'Connection error: {e}')
        
async def get_md_files(urls):
    async with aiohttp.ClientSession() as session:
        tasks = []
        for url in urls:
            tasks.append(get_md_file(session, url))

        results = await asyncio.gather(*tasks)
        return results


async def get_md_file(session, url):
    try:
        async with session.get(url['url']) as response:
            if response.status == 200:
                text = await response.text()
                return {
                    'category': url['category'],
                    'subcategory': url['subcategory'],
                    'name': url['name'],
                    'file': text,
                }
            else:
                log.info(response.status)
    except aiohttp.ClientConnectionError as e:
        log.error(f'Connection error: {e}')


def get_file(url):
    try:
        r = requests.get(url)
        r.raise_for_status()

    except requests.exceptions.HTTPError as e:
        log.error(
            f"Error fetching {url}: \n{e}")

    return r.json()
