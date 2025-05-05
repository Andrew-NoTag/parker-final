from fastapi import FastAPI, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import func
from sqlalchemy.sql import cast
from sqlalchemy.types import String
from . import models, schemas
from .database import engine, get_db

app = FastAPI(title="Parking Finder API", version="1.0")

@app.get("/")
def read_root():
    return {"message": "Welcome to Parking Finder API"}

# @app.get("/parking-lots", response_model=list[schemas.ParkingLot])
# def get_parking_lots(db: Session = Depends(get_db)):
#     lots = db.query(models.ParkingLot).all()
#     return lots

@app.get("/closest-parking-lots", response_model=list[schemas.CombinedLotSchema])
def get_closest_parking_lots(
    latitude: float = Query(..., description="Latitude of the user's location"),
    longitude: float = Query(..., description="Longitude of the user's location"),
    limit: int = Query(200, description="Number of parking lots to fetch"),
    db: Session = Depends(get_db)
):
    # Query parking lots and join with block_restrictions
    lots = (
        db.query(
            models.ParkingLot.id,
            models.ParkingLot.street_name,
            models.ParkingLot.latitude,
            models.ParkingLot.longitude,
            models.ParkingLot.status,
            models.ParkingLot.last_updated,
            models.BlockRestriction.day,
            models.BlockRestriction.start_time,
            models.BlockRestriction.end_time,
            models.BlockRestriction.time_limit_minutes
        )
        .outerjoin(
            models.BlockRestriction,
            models.ParkingLot.id == models.BlockRestriction.block_id
        )
        .order_by(
            func.sqrt(
                func.pow(models.ParkingLot.latitude - latitude, 2) +
                func.pow(models.ParkingLot.longitude - longitude, 2)
            )
        )
        .limit(limit)
        .all()
    )

    # Format the results into a list of dictionaries
    result = []
    for lot in lots:
        result.append({
            "id": lot.id,
            "street_name": lot.street_name,
            "latitude": lot.latitude,
            "longitude": lot.longitude,
            "status": lot.status,
            "last_updated": lot.last_updated,
            "day": lot.day,
            "start_time": lot.start_time,
            "end_time": lot.end_time,
            "time_limit_minutes": lot.time_limit_minutes
        })
    return result

@app.put("/update-parking-status", response_model=dict)
def update_parking_status(
    latitude: float = Query(..., description="Latitude of the user's location"),
    longitude: float = Query(..., description="Longitude of the user's location"),
    db: Session = Depends(get_db)
):
    # Find the closest parking lot
    closest_parking_lot = (
        db.query(models.ParkingLot)
        .order_by(
            func.sqrt(
                func.pow(models.ParkingLot.latitude - latitude, 2) +
                func.pow(models.ParkingLot.longitude - longitude, 2)
            )
        )
        .first()
    )

    if not closest_parking_lot:
        raise HTTPException(status_code=404, detail="No parking lot found")

    # Update the status to available
    closest_parking_lot.status = "available"
    db.commit()
    db.refresh(closest_parking_lot)

    return {
        "parking_lot": {
            "id": closest_parking_lot.id,
            "street_name": closest_parking_lot.street_name,
            "latitude": closest_parking_lot.latitude,
            "longitude": closest_parking_lot.longitude,
            "status": closest_parking_lot.status,
        }
    }

