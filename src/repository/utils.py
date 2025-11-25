from db.database import db
import logging
import psycopg

log = logging.getLogger(__name__)


def execute_update(query, params=None):
    """Execute an INSERT, UPDATE, or DELETE statement."""
    try:
        with db.conn.cursor() as cur:
            cur.execute(query, params)
            db.conn.commit()
            log.info(f"{cur.rowcount} row(s) affected.")
            row = cur.fetchone()
            if (row):
                return row
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
        db.conn.rollback()

        return None


def fetch_many(query, params=None):
    """Fetch multiple rows as a list of dicts."""
    try:
        with db.conn.cursor() as cur:
            cur.execute(query, params)
            rows = cur.fetchall()

            # if not rows:
            #     return []

            columns = [desc[0] for desc in cur.description]
            return [dict(zip(columns, row)) for row in rows]
    except psycopg.Error as e:
        log.error(f"Database error executing fetch_many:\n{query}\n{e}")
        db.conn.rollback()
        return []
