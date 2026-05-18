from dotenv import load_dotenv
from sqlalchemy import create_engine
import logging
import os

gis_host = os.getenv("GIS_DB_HOST")
gis_dbname = os.getenv("GIS_DB_NAME")
gis_user = os.getenv("GIS_DB_USER")
gis_password = os.getenv("GIS_DB_PASS")
gis_port = os.getenv("GIS_DB_PORT")

write_host = os.getenv("WRITE_DB_HOST")
write_dbname = os.getenv("WRITE_DB_NAME")
write_user = os.getenv("WRITE_DB_USER")
write_password = os.getenv("WRITE_DB_PASS")
write_port = os.getenv("WRITE_DB_PORT")

log = logging.getLogger(__name__)
load_dotenv()


def get_gis_engine():
    return create_engine(f"postgresql://{gis_user}:{gis_password}@{gis_host}:{gis_port}/{gis_dbname}", connect_args={"connect_timeout": 10})


def get_write_engine():
    return create_engine(f"postgresql://{write_user}:{write_password}@{write_host}:{write_port}/{write_dbname}", connect_args={"connect_timeout": 10})
