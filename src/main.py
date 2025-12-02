from fastapi import FastAPI
from routers import profile, content, viz, source, tree
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI

from fastapi_cache import FastAPICache
from fastapi_cache.backends.redis import RedisBackend
from fastapi_cache.decorator import cache

from redis import asyncio as aioredis
import logging

origins = [
    "http://localhost",
    "http://localhost:3000",
    "https://cloud.dvrpc.org/community-profiles",

]

log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)


@asynccontextmanager
async def lifespan(_: FastAPI) -> AsyncIterator[None]:
    redis = aioredis.from_url("redis://localhost")
    FastAPICache.init(RedisBackend(redis), prefix="fastapi-cache")
    yield

app = FastAPI(lifespan=lifespan)
app.include_router(profile.router)
app.include_router(content.router)
app.include_router(viz.router)
app.include_router(source.router)
app.include_router(tree.router)

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
