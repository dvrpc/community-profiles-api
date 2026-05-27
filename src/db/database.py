from dotenv import load_dotenv

import os
import psycopg
import logging

log = logging.getLogger(__name__)


class Database:
    def __init__(self):
        self.conn: psycopg.AsyncConnection | None = None

    async def connect(self) -> None:
        """Establish an async connection to Postgres and store it on the instance."""
        log.info("Connecting to PostgreSQL Database (async)...")
        load_dotenv()
        try:
            self.conn = await psycopg.AsyncConnection.connect(
                host=os.getenv("DB_HOST"),
                dbname=os.getenv("DB_NAME"),
                user=os.getenv("DB_USER"),
                password=os.getenv("DB_PASS"),
                port=os.getenv("DB_PORT"),
            )
        except Exception as e:
            log.error(f"Could not connect to Database: {e}")

    async def close(self) -> None:
        if self.conn is not None:
            await self.conn.close()


db = Database()
