from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from database import SessionLocal
import models

app = FastAPI()

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/users")
def read_users(db: Session = Depends(get_db)):
    users = db.query(models.User).all()
    return users

@app.post("/users")
def create_user(name: str, age: int, db: Session = Depends(get_db)):
    new_user = models.User(name=name, age=age)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user