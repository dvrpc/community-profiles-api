## Community Profiles API

1. Activate venv
```
python -m venv .venv
source .venv/bin/activate
# Windows .venv\Scripts\activate
```
2. Install requirements `pip install -r requirements.txt`
3. Create .env file and fill contents from env_sample. This points to the DB create for [community-profiles-data-builder](https://github.com/dvrpc/community-profiles-data-builder)
5. Run app
```
cd src
uvicorn main:app --reload
```
TEST DATA
tract = 42091204702
muni = 4201704976
county = 42101
