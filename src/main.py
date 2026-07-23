from fastapi import FastAPI
from routers import profile, content, viz, source, tree, variable, data_builder, sql, acs
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI

from fastapi_cache import FastAPICache
from fastapi_cache.backends.redis import RedisBackend
from fastapi_cache.decorator import cache

from redis import asyncio as aioredis
import logging
from db.database import db

origins = [
    "http://localhost",
    "http://localhost:3000",
    "https://cloud.dvrpc.org/community-profiles",

]

# Configure root logger for the entire application
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s"
)
log = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(_: FastAPI) -> AsyncIterator[None]:
    global redis_client
    redis_client = aioredis.from_url(
        "redis://localhost",
        max_connections=10,  
        socket_connect_timeout=5,
        socket_timeout=5,
        health_check_interval=30,
    )
    FastAPICache.init(RedisBackend(redis_client), prefix="fastapi-cache")

    await db.connect()
    yield

    await db.close()
    if redis_client is not None:
        await redis_client.close()
        log.info("Redis connection closed.")

app = FastAPI(lifespan=lifespan)
app.include_router(profile.router)
app.include_router(content.router)
app.include_router(viz.router)
app.include_router(source.router)
app.include_router(tree.router)
app.include_router(variable.router)
app.include_router(data_builder.router)
app.include_router(sql.router)
app.include_router(acs.router)

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@cache()
async def get_cache():
    return 1


@app.get("/")
def root():
    return {"message": "Hello World"}

@app.get("/health")
async def health():
    db_ok = db.healthy and db.pool is not None
    redis_ok = False
    if redis_client is not None:
        try:
            await redis_client.ping()
            redis_ok = True
        except Exception:
            redis_ok = False
    status = "ok" if (db_ok and redis_ok) else "degraded"
    return {"status": status, "db": db_ok, "redis": redis_ok}