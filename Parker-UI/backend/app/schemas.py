from pydantic import BaseModel

class ParkingLotBase(BaseModel):
    id: int
    street_name: str 
    latitude: float
    longitude: float

    class Config:
        from_attributes = True

class ParkingLotCreate(ParkingLotBase):
    pass

class ParkingLot(ParkingLotBase):
    id: int

    class Config:
        from_attributes = True
