from dotenv import load_dotenv
from sqlalchemy import create_engine
import logging
import os

gis_host = os.getenv("GIS_HOST")
gis_dbname = os.getenv("GIS_NAME")
gis_user = os.getenv("GIS_USER")
gis_password = os.getenv("GIS_PASS")
gis_port = os.getenv("GIS_PORT")

log = logging.getLogger(__name__)
load_dotenv()


def get_gis_engine():
    return create_engine(f"postgresql://{gis_user}:{gis_password}@{gis_host}:{gis_port}/{gis_dbname}", connect_args={"connect_timeout": 10})
