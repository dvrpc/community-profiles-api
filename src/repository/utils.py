from db.database import db
import logging
import psycopg

log = logging.getLogger(__name__)


async def execute_update(query, params=None):
    """Execute an INSERT, UPDATE, or DELETE statement (async)."""
    try:
        async with db.conn.cursor() as cur:
            await cur.execute(query, params)
            await db.conn.commit()
            log.info(f"{cur.rowcount} row(s) affected.")
            row = await cur.fetchone()
            if row:
                return row
            return cur.rowcount
    except psycopg.Error as e:
        log.error(f"Database error executing update:\n{query}\n{e}")
        await db.conn.rollback()
        return None


async def execute_alter(query, params=None):
    try:
        async with db.conn.cursor() as cur:
            await cur.execute(query, params)
            await db.conn.commit()
            log.info("ALTER executed successfully.")
    except psycopg.Error as e:
        log.error(f"Database error executing alter:\n{query}\n{e}")
        await db.conn.rollback()


async def fetch_one(query, params=None):
    """Fetch a single row as a dict (async)."""
    try:
        async with db.conn.cursor() as cur:
            await cur.execute(query, params)
            row = await cur.fetchone()
            if not row:
                return None
            columns = [desc[0] for desc in cur.description]
            return dict(zip(columns, row))
    except psycopg.Error as e:
        log.error(f"Database error executing fetch_one:\n{query}\n{e}")
        await db.conn.rollback()
        return None


async def fetch_many(query, params=None):
    """Fetch multiple rows as a list of dicts (async)."""
    try:
        async with db.conn.cursor() as cur:
            await cur.execute(query, params)
            rows = await cur.fetchall()
            columns = [desc[0] for desc in cur.description]
            return [dict(zip(columns, row)) for row in rows]
    except psycopg.Error as e:
        log.error(f"Database error executing fetch_many:\n{query}\n{e}")
        await db.conn.rollback()
        return []
