from fastapi import FastAPI
from routers import profile, content


app = FastAPI()
app.include_router(profile.router)
app.include_router(content.router)


@app.get("/")
def root():
    return {"message": "Hello World"}
