from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer
from google.oauth2 import id_token
from google.auth.transport import requests
from dotenv import load_dotenv
import os 

load_dotenv()

security = HTTPBearer()
GOOGLE_CLIENT_ID = os.getenv("GOOGLE_CLIENT_ID")
ALLOWED_DOMAIN = "dvrpc.org"
ALLOWED_EMAILS = {"ckirby@dvrpc.org"}

async def require_admin(credentials=Depends(security)):
    try:
        # Verify the Google ID token
        idinfo = id_token.verify_oauth2_token(
            credentials.credentials,
            requests.Request(),
            GOOGLE_CLIENT_ID
        )

        email = idinfo.get("email")
        domain = idinfo.get("hd")  # hosted domain from Google token

        if not email:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Missing email in token"
            )

        # Check domain
        if domain != ALLOWED_DOMAIN:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Forbidden: invalid domain"
            )

        # Check email whitelist
        if email not in ALLOWED_EMAILS:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Forbidden: email not allowed"
            )

        # Token is valid and email is allowed; we don't need to return user info
        return True

    except Exception:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials"
        )