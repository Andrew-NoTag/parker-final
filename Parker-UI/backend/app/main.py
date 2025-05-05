from fastapi import FastAPI, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import func
from . import models, schemas
from .database import engine, get_db

app = FastAPI(title="Parking Finder API", version="1.0")

@app.get("/")
def read_root():
    return {"message": "Welcome to Parking Finder API"}

@app.get("/parking-lots", response_model=list[schemas.ParkingLot])
def get_parking_lots(db: Session = Depends(get_db)):
    lots = db.query(models.ParkingLot).all()
    return lots

@app.get("/closest-parking-lots", response_model=list[schemas.ParkingLot])
def get_closest_parking_lots(
    latitude: float = Query(..., description="Latitude of the user's location"),
    longitude: float = Query(..., description="Longitude of the user's location"),
    limit: int = Query(50, description="Number of parking lots to fetch"),
    db: Session = Depends(get_db)
):
    lots = (
        db.query(models.ParkingLot)
        .order_by(
            func.sqrt(
                func.pow(models.ParkingLot.latitude - latitude, 2) +
                func.pow(models.ParkingLot.longitude - longitude, 2)
            )
        )
        .limit(limit)
        .all()
    )
    return lots

@app.put("/update-parking-status", response_model=schemas.ParkingLot)
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
    closest_parking_lot.status = "available"  # Assuming there's a `status` column in the `ParkingLot` model
    db.commit()
    db.refresh(closest_parking_lot)

    return closest_parking_lot

