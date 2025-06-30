from fastapi import FastAPI
from routers import profile


app = FastAPI()
app.include_router(profile.router)

@app.get("/")
def root():
    return {"message": "Hello World"}
