## Community Profiles API

1. Activate venv

```
python -m venv .venv
source .venv/bin/activate
# Windows .venv\Scripts\activate
```

2. Install requirements `pip install -r requirements.txt`
3. Create .env file and fill contents from env_sample. This points to the postgres DB created for [community-profiles-data-builder](https://github.com/dvrpc/community-profiles-data-builder)
   - The revalidate url should be `<yourfrontendurl>/api/revalidate`
   - The revalidate secret can be any secret that matches the frontend secret
4. Get a Github fine grained personal access token with read access to https://github.com/dvrpc/community-profiles-content
5. Run app

```
cd src
uvicorn main:app --reload
```

TEST DATA
tract = 42091204702
muni = 4201704976
county = 42101
