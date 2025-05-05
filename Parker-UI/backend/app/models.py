from .database import Base
from sqlalchemy import Column, Integer, String, Float, DateTime

class ParkingLot(Base):
    __tablename__ = "parking_lots"
    
    id = Column(Integer, primary_key=True, index=True)
    street_name = Column(String, nullable=False)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    zip_code = Column(String, nullable=True)
    borough = Column(String, nullable=True) 
    last_updated = Column(DateTime, nullable=True)
