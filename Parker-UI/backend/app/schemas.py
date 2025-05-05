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
    password_hash: str
    credits: int

    class Config:
        from_attributes = True


class UserCreate(BaseModel):
    id: str  # Use `id` for registration
    password: str  # Plaintext password for registration


class UserLogin(BaseModel):
    id: str  # Use `id` for login
    password: str  # Plaintext password for login


class UserResponse(BaseModel):
    id: str
    credits: int

    class Config:
        from_attributes = True