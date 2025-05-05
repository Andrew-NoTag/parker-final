from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class ParkingLotBase(BaseModel):
    id: str
    street_name: str 
    latitude: float
    longitude: float
    status: str
    last_updated: Optional[str] = None

    class Config:
        from_attributes = True

class ParkingLotCreate(ParkingLotBase):
    pass

class ParkingLot(ParkingLotBase):
    id: str

    class Config:
        from_attributes = True
