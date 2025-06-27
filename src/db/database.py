from typing import cast
from fastapi import Request
from psycopg import Connection
from psycopg_pool import AsyncConnectionPool
from dotenv import load_dotenv
# You should be using environment variables in a settings file here
import os

load_dotenv()

DB_USER = os.environ.get("DB_USER")
DB_PASS = os.environ.get("DB_PASS")
DB_PORT = os.environ.get("DB_PORT")
DB_HOST = os.environ.get("DB_HOST")
DB_NAME = os.environ.get("DB_NAME")

conninfo = f'host={DB_HOST} port={DB_PORT} dbname={DB_NAME} user={DB_USER} password={DB_PASS}'

def get_db_connection_pool() -> AsyncConnectionPool:
    """Get the connection pool for psycopg.

    NOTE the pool connection is opened in the FastAPI server startup (lifespan).

    Also note this is also a sync `def`, as it only returns a context manager.
    """
    return AsyncConnectionPool(
        conninfo=conninfo, open=False
    )


async def db_conn(request: Request) -> Connection:
    """Get a connection from the psycopg pool.

    Info on connections vs cursors:
    https://www.psycopg.org/psycopg3/docs/advanced/async.html

    Here we are getting a connection from the pool, which will be returned
    after the session ends / endpoint finishes processing.

    In summary:
    - Connection is created on endpoint call.
    - Cursors are used to execute commands throughout endpoint.
      Note it is possible to create multiple cursors from the connection,
      but all will be executed in the same db 'transaction'.
    - Connection is closed on endpoint finish.
    """
    db_pool = cast(AsyncConnectionPool, request.state.db_pool)
    async with db_pool.connection() as conn:
        yield conn
