from datetime import datetime
from fastapi_cache.decorator import cache
from db.database import db
import logging
import psycopg
import json

log = logging.getLogger(__name__)

def execute_update(query, params=None):
    """Execute an INSERT, UPDATE, or DELETE statement."""
    print(query)
    print(params)
    try:
        with db.conn.cursor() as cur:
            cur.execute(query, params)
            db.conn.commit()
            log.info(f"{cur.rowcount} row(s) affected.")
            return cur.rowcount
    except psycopg.Error as e:
        log.error(f"Database error executing update:\n{query}\n{e}")
        db.conn.rollback()
        return None


def fetch_one(query, params=None):
    """Fetch a single row as a dict."""
    try:
        with db.conn.cursor() as cur:
            cur.execute(query, params)
            row = cur.fetchone()
            if not row:
                return None
            columns = [desc[0] for desc in cur.description]
            return dict(zip(columns, row))
    except psycopg.Error as e:
        log.error(f"Database error executing fetch_one:\n{query}\n{e}")
        return None


def fetch_many(query, params=None):
    """Fetch multiple rows as a list of dicts."""
    try:
        with db.conn.cursor() as cur:
            cur.execute(query, params)
            rows = cur.fetchall()
            columns = [desc[0] for desc in cur.description]
            return [dict(zip(columns, row)) for row in rows]
    except psycopg.Error as e:
        log.error(f"Database error executing fetch_many:\n{query}\n{e}")
        return []


@cache(expire=60)
async def fetch_county(geoid):
    log.info(f"Fetching county profile: {geoid}")
    query = "SELECT * FROM county WHERE geoid = %s"
    return fetch_one(query, (geoid,))


@cache(expire=60)
async def fetch_municipality(geoid):
    log.info(f"Fetching municipality profile: {geoid}")
    query = "SELECT * FROM municipality WHERE geoid = %s"
    return fetch_one(query, (geoid,))


@cache(expire=60)
async def fetch_region():
    log.info("Fetching regional profile")
    query = "SELECT * FROM region"
    return fetch_one(query)


@cache(expire=60)
async def fetch_content(geo_level):
    log.info(f"Fetching {geo_level} content...")
    query = """
        SELECT category, subcategory, name, file
        FROM content
        WHERE geo_level = %s
    """
    return fetch_many(query, (geo_level,))


@cache(expire=60)
async def fetch_visualizations(geo_level, category, subcategory, topic):
    log.info(f"Fetching {geo_level}/{category}/{subcategory}/{topic} visualizations...")
    query = """
        SELECT file
        FROM visualizations
        WHERE geo_level = %s
          AND category = %s
          AND subcategory = %s
          AND name = %s
    """
    result = fetch_one(query, (geo_level, category, subcategory, topic))
    return json.loads(result["file"]) if result else None


async def fetch_content_template(geo_level, category, subcategory, topic):
    log.info(f"Fetching {geo_level}/{category}/{subcategory}/{topic} content template...")
    query = """
        SELECT file
        FROM content
        WHERE geo_level = %s
          AND category = %s
          AND subcategory = %s
          AND name = %s
    """
    result = fetch_one(query, (geo_level, category, subcategory, topic))
    return result["file"] if result else None


async def fetch_viz_template(geo_level, category, subcategory, topic):
    log.info(f"Fetching {geo_level}/{category}/{subcategory}/{topic} viz template...")
    query = """
        SELECT file
        FROM visualizations
        WHERE geo_level = %s
          AND category = %s
          AND subcategory = %s
          AND name = %s
    """
    result = fetch_one(query, (geo_level, category, subcategory, topic))
    return json.loads(result["file"]) if result else None


async def fetch_template_tree(geo_level):
    query = "SELECT category, subcategory, name FROM content WHERE geo_level = %s"
    return fetch_many(query, (geo_level,))


async def fetch_single_content(category, subcategory, topic, geo_level):
    log.info(f"Fetching {category}/{subcategory}/{topic} content...")
    query = """
        SELECT *
        FROM content
        WHERE category = %s
          AND subcategory = %s
          AND name = %s
          AND geo_level = %s
    """
    return fetch_one(query, (category, subcategory, topic, geo_level))


async def update_single_content(category, subcategory, topic, geo_level, body):
    now = datetime.now()
    log.info(f"Updating content for {category}/{subcategory}/{topic}/{geo_level}")
    query = """
        UPDATE content
        SET file = %s, create_date = %s
        WHERE category = %s AND subcategory = %s AND name = %s AND geo_level = %s
    """
    return execute_update(query, (body, now, category, subcategory, topic, geo_level))

async def create_content_history(dict):
    columns = ', '.join(dict.keys())
    placeholders = ', '.join(['%s'] * len(dict))
    values = tuple(dict.values())

    query = f"INSERT INTO content_history ({columns}) VALUES ({placeholders})"

    log.info(f"Inserting row into content_history...")
    return execute_update(query, values)