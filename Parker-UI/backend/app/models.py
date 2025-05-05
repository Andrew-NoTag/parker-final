from .database import Base
from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship

class ParkingLot(Base):
    __tablename__ = "parking_lots"
    
    id = Column(String, primary_key=True, index=True)
    street_name = Column(String, nullable=False)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    status = Column(String, nullable=True)
    last_updated = Column(String, nullable=True)

class BlockRestriction(Base):
    __tablename__ = "block_restrictions"
    
    id = Column(String, primary_key=True, index=True)
    block_id = Column(String)  # Foreign key to ParkingLot
    day = Column(String, nullable=False)  # e.g., "Monday"
    start_time = Column(String, nullable=False)  # e.g., "08:00"
    end_time = Column(String, nullable=False)  # e.g., "18:00"
    time_limit_minutes = Column(Integer, nullable=True)  # Optional time limit in minutes

class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, index=True)
    password_hash = Column(String(255), nullable=False)
    credits = Column(Integer, default=0)

