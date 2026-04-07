from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

items = {}

class Item(BaseModel):
    name: str
    price: float
    is_available: bool = True

@app.get("/")
def get_root():
    return {"message": "Welcome to the Item API"}

@app.get("/items")
def get_items():
    return items

@app.get("/items/{item_id}")
def get_item(item_id: int):
    if item_id not in items:
        raise HTTPException(status_code=404, detail="Item not found")
    return items[item_id]

@app.post("/items")
def create_item(item_id: int, item: Item):
    if item_id in items:
        raise HTTPException(status_code=400, detail="Item already exists")
    items[item_id] = item
    return {"message": "Item created", "data": item}

@app.put("/items/{item_id}")
def update_item(item_id: int, item: Item):
    if item_id not in items:
        raise HTTPException(status_code=404, detail="Item not found")
    items[item_id] = item
    return {"message": "Item updated", "data": item}