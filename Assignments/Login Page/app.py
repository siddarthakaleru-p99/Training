from fastapi import FastAPI, Depends, HTTPException, Form
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from passlib.context import CryptContext
from jose import jwt
from datetime import datetime, timedelta
from fastapi.responses import HTMLResponse

# CONFIG
DATABASE_URL = "sqlite:///./test.db"
SECRET_KEY = "39463ef32b572d080d7145065664744a7af34221d28ff7b79666e5f94178b3b1" # Keep this private in real apps
ALGORITHM = "HS256"

# DB SETUP
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    hashed_password = Column(String)

Base.metadata.create_all(bind=engine)

# HASHING
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

app = FastAPI()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/", response_class=HTMLResponse)
def serve_html():
    with open("index.html", "r") as f:
        return f.read()

# --- REGISTER ---
@app.post("/register")
def register(username: str = Form(...), password: str = Form(...), db: Session = Depends(get_db)):
    if db.query(User).filter(User.username == username).first():
        raise HTTPException(status_code=400, detail="User exists")
    
    # Truncate password to 72 chars just in case to prevent the ValueError
    safe_password = password[:72]
    new_user = User(username=username, hashed_password=pwd_context.hash(safe_password))
    db.add(new_user)
    db.commit()
    return {"message": "Registered successfully"}

# --- LOGIN (This fixes the 404) ---
@app.post("/token")
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == form_data.username).first()
    if not user or not pwd_context.verify(form_data.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    token = jwt.encode({"sub": user.username}, SECRET_KEY, algorithm=ALGORITHM)
    return {"access_token": token, "token_type": "bearer"}