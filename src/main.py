from typing import AsyncIterator
from contextlib import asynccontextmanager
from fastapi import FastAPI
from routers import profile

from db.database import get_db_connection_pool

@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    """FastAPI startup/shutdown event."""
    print("Starting up FastAPI server.")

    # Create a pooled db connection and make available in lifespan state
    # https://asgi.readthedocs.io/en/latest/specs/lifespan.html#lifespan-state
    # NOTE to use within a request (this is wrapped in database.py already):
    # from typing import cast
    # db_pool = cast(AsyncConnectionPool, request.state.db_pool)
    # async with db_pool.connection() as conn:
    db_pool = get_db_connection_pool()
    await db_pool.open()

    yield

    # Shutdown events
    print("Shutting down FastAPI server.")
    # Here we make sure to close the connection pool
    await db_pool.close()


app = FastAPI()

app.include_router(profile.router)

@app.get("/")
async def root():
    return {"message": "Hello World"}
