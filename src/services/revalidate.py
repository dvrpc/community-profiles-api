import requests
import os
import logging
from dotenv import load_dotenv

load_dotenv()
REVALIDATE_SECRET = os.getenv("REVALIDATE_SECRET")
FRONTEND_REVALIDATE_URL = os.getenv("FRONTEND_REVALIDATE_URL")

log = logging.getLogger(__name__)

def revalidate_frontend(geo_level: str):
    payload = {"geoLevel": geo_level}
    headers = {"Authorization": f"Bearer {REVALIDATE_SECRET}"}

    try:
        r = requests.post(FRONTEND_REVALIDATE_URL, headers=headers, json=payload, timeout=10)
        r.raise_for_status()
        log.info("Revalidated:", r.json())
        print("Revalidated:", r.json())
    except Exception as e:
        log.info("Revalidation failed:", e)