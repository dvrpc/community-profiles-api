from db.database import db
import logging
import psycopg

log = logging.getLogger(__name__)


async def execute_update(query, params=None):
    """Execute an INSERT, UPDATE, or DELETE statement (async)."""
    try:
        async with db.pool.connection() as conn:
            async with conn.cursor() as cur:
                await cur.execute(query, params)
                row = await cur.fetchone()
                if row:
                    return row
                return cur.rowcount
    except psycopg.Error as e:
        log.error(f"Database error executing update:\n{query}\n{e}")
        return None


async def execute_bulk_upsert(query, rows) -> dict | None:
    try:
        async with db.pool.connection() as conn:
            async with conn.cursor() as cur:
                await cur.executemany(query, rows, returning=True)

                inserted_ids, updated_ids = [], []
                while True:
                    row = await cur.fetchone()
                    if row:
                        id_, was_updated = row
                        (updated_ids if was_updated else inserted_ids).append(id_)
                    if not cur.nextset():  # synchronous, returns False when no more sets
                        break

                log.info(
                    f"Bulk upsert: {len(inserted_ids)} inserted, {len(updated_ids)} updated")
                return {"inserted": inserted_ids, "updated": updated_ids}
    except psycopg.Error as e:
        log.error(f"Database error executing bulk upsert:\n{query}\n{e}")
        return None


async def execute_alter(query, params=None):
    try:
        async with db.pool.connection() as conn:
            async with conn.cursor() as cur:
                await cur.execute(query, params)
        log.info("ALTER executed successfully.")
    except psycopg.Error as e:
        log.error(f"Database error executing alter:\n{query}\n{e}")


async def fetch_one(query, params=None):
    """Fetch a single row as a dict (async)."""
    try:
        async with db.pool.connection() as conn:
            async with conn.cursor() as cur:
                await cur.execute(query, params)
                row = await cur.fetchone()
                if not row:
                    return None
                columns = [desc[0] for desc in cur.description]
                return dict(zip(columns, row))
    except psycopg.Error as e:
        log.error(f"Database error executing fetch_one:\n{query}\n{e}")
        return None


async def fetch_many(query, params=None):
    """Fetch multiple rows as a list of dicts (async)."""
    try:
        async with db.pool.connection() as conn:
            async with conn.cursor() as cur:
                await cur.execute(query, params)
                rows = await cur.fetchall()
                columns = [desc[0] for desc in cur.description]
                return [dict(zip(columns, row)) for row in rows]
    except psycopg.Error as e:
        log.error(f"Database error executing fetch_many:\n{query}\n{e}")
        return []
