from sqlalchemy import Column, Integer, String, Float, Boolean
from sqlalchemy.orm import declarative_base

Base = declarative_base()

class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True, nullable=False)
    description = Column(String, default="")
    price = Column(Float, nullable=False)
    # For simplicity, we'll store an image URL. You could store base64 or a file path later.
    image_url = Column(String, default="")
    category = Column(String, default="Uncategorized")
    is_available = Column(Boolean, default=True)