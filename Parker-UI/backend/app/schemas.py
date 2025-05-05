from pydantic import BaseModel
from datetime import datetime

class ParkingLotBase(BaseModel):
    id: int
    street_name: str 
    latitude: float
    longitude: float
    zip_code: str | None = None  # New field
    borough: str | None = None  # New field
    last_updated: datetime | None = None  # New field

    class Config:
        from_attributes = True

class ParkingLotCreate(ParkingLotBase):
    pass

class ParkingLot(ParkingLotBase):
    id: int

    class Config:
        from_attributes = True
