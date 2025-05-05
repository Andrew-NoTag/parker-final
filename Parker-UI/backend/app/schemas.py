from pydantic import BaseModel
from datetime import datetime
from typing import Optional

"""parking_lots"""
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

"""block_restrictions"""
class BlockRestrictionBase(BaseModel):
    id: str
    block_id: str
    day: str
    start_time: str
    end_time: str
    time_limit_minutes: Optional[int] = None

    class Config:
        from_attributes = True

class BlockRestrictionCreate(BlockRestrictionBase):
    pass

class BlockRestriction(BlockRestrictionBase):
    pass

"""combined_lots"""
class CombinedLotSchema(BaseModel):
    id: str
    street_name: str
    latitude: float
    longitude: float
    status: str
    last_updated: str
    day: Optional[str]
    start_time: Optional[str]
    end_time: Optional[str]
    time_limit_minutes: Optional[int]

"""users"""
class UserBase(BaseModel):
    id: str
    name: str
    email: str
    credits: int

    class Config:
        from_attributes = True


class UserCreate(BaseModel):
    name: str
    email: str
    password: str


class User(UserBase):
    pass
