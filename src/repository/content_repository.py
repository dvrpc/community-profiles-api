import requests
import os
import logging
import asyncio
import aiohttp
from dotenv import load_dotenv

log = logging.getLogger(__name__)

load_dotenv()
token = os.getenv("GITHUB_TOKEN")
headers = {
    "Authorization": f"Bearer {token}"
}
base_contents_url = "https://api.github.com/repos/dvrpc/community-profiles-content/contents/"

# https://raw.githubusercontent.com/{owner}/{repo}/{branch}/README.md


def get_download_urls(geo_level, type):
    url = base_contents_url + geo_level + f'/{type}'
    try:
        r = requests.get(url, headers=headers)
        r.raise_for_status()

    except requests.exceptions.HTTPError as e:
        log.error(
            f"Error fetching {geo_level} contents: \n{e}")

    download_urls = []
    data = r.json()

    for files in data:
        # download_urls.append(files['download_url'])
        index = -3 if type == 'md' else -5
        download_urls.append({
            'name': files['name'][:index],
            'type': type,
            'url': files['download_url'],
        })
    return download_urls

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
                    'type': url['type'],
                    'name': url['name'],
                    'file': text,

                }
            else:
                log.info(response.status)
    except aiohttp.ClientConnectionError as e:
        log.error(f'Connection error: {e}')

