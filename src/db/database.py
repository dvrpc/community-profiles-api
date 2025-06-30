from typing import cast
from fastapi import Request
from dotenv import load_dotenv

import os
import psycopg
import logging

log = logging.getLogger(__name__)

class Database:
    def __init__(self):
        self.conn = self.connect()

    def connect(self):
        """
        Connect to database and return connection
        """
        log.info("Connecting to PostgreSQL Database...")
        try:
            load_dotenv()

            conn = psycopg.connect(
                host = os.getenv("DB_HOST"),
                dbname = os.getenv("DB_NAME"),
                user = os.getenv("DB_USER"),
                password = os.getenv("DB_PASS"),
                port = os.getenv("DB_PORT")
            )
        except psycopg.OperationalError as e:
            log.error(f"Could not connect to Database: {e}")

        return conn
    
db = Database()
