import requests
import os
import logging
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
    print(url)
    try:
        r = requests.get(url, headers=headers)
        r.raise_for_status()

    except requests.exceptions.HTTPError as e:
        log.error(
            f"Error fetching {geo_level} contents: \n{e}")

    download_urls = []
    data = r.json()

    for files in data:
        download_urls.append({
            'name': files['name'][:-3],
            'url': files['download_url'],
        })
    return download_urls


def get_file(url):
    try:
        r = requests.get(url, headers=headers)
        r.raise_for_status()

    except requests.exceptions.HTTPError as e:
        log.error(
            f"Error fetching {url}: \n{e}")

    return r.text
