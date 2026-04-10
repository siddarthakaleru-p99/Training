from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

class user(BaseModel):
    name: str
    age: int

@app.get("/")
def get_root():
    return {"message": "Welcome to the User API"}

@app.post("/users")
def create_user(user_id: int, user: user):
    return {"message": "User created", "data": user}