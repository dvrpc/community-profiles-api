from dotenv import load_dotenv
import os
import logging
from psycopg_pool import AsyncConnectionPool

log = logging.getLogger(__name__)

class Database:
    def __init__(self):
        self.pool: AsyncConnectionPool | None = None

    async def connect(self) -> None:
        load_dotenv()
        conninfo = (
            f"host={os.getenv('DB_HOST')} "
            f"dbname={os.getenv('DB_NAME')} "
            f"user={os.getenv('DB_USER')} "
            f"password={os.getenv('DB_PASS')} "
            f"port={os.getenv('DB_PORT')}"
        )
        try:
            self.pool = AsyncConnectionPool(
                conninfo=conninfo,
                open=False,
                min_size=1,
                max_size=5,
                max_idle=300,
                max_lifetime=1800,
                reconnect_timeout=30,
                num_workers=2,
                kwargs={"options": "-c statement_timeout=15000"},
            )
            await self.pool.open()
            log.info("Database connection pool created.")
        except Exception as e:
            log.error(f"Could not create database pool: {e}")

    async def close(self) -> None:
        if self.pool is not None:
            await self.pool.close()
            log.info("Database connection pool closed.")

db = Database()