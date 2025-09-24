from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
import os
import uvicorn

app = FastAPI(title="Mpepo Kitchen API")

# Enable CORS for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # For development only!
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Product model
class Product(BaseModel):
    id: int
    name: str
    description: str = ""
    price: float
    image_url: str = ""
    category: str = "Uncategorized"
    is_available: bool = True

# Temporary mock data
mock_products = [
    Product(id=1, name="Chicken Burger", description="Juicy grilled chicken burger with fresh veggies", price=12.99, category="Burgers"),
    Product(id=2, name="Vegetable Pizza", description="Fresh vegetable pizza with mozzarella cheese", price=15.99, category="Pizza"),
    Product(id=3, name="French Fries", description="Crispy golden fries with seasoning", price=5.99, category="Sides")
]

@app.get("/")
async def root():
    return {"message": "Mpepo Kitchen API is running!"}

@app.get("/products", response_model=List[Product])
async def get_products():
    return mock_products

@app.get("/products/{product_id}", response_model=Product)
async def get_product(product_id: int):
    for product in mock_products:
        if product.id == product_id:
            return product
    return {"error": "Product not found"}

# --- Run with Railway port ---
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
