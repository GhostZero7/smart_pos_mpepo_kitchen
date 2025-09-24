from pydantic import BaseModel

# Base properties for a product
class ProductBase(BaseModel):
    name: str
    description: str | None = None
    price: float
    image_url: str | None = None
    category: str | None = "Uncategorized"
    is_available: bool = True

# Schema for creating a product (inherits from base)
class ProductCreate(ProductBase):
    pass

# Schema for returning a product (includes the ID from the database)
class Product(ProductBase):
    id: int

    class Config:
        from_attributes = True  # Allows ORM mode (formerly `orm_mode = True`)