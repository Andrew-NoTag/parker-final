from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from . import models, schemas
from .database import engine, get_db

app = FastAPI(title="Parking Finder API", version="1.0")

@app.get("/")
def read_root():
    return {"message": "Welcome to Parking Finder API"}

@app.get("/parking-lots", response_model=list[schemas.ParkingLot])
def get_parking_lots(db: Session = Depends(get_db)):
    lots = db.query(models.ParkingLot).limit(4).all()
    return lots

#@app.post("/parking-lots", response_model=schemas.ParkingLot)
#def create_parking_lot(lot: schemas.ParkingLotCreate, db: Session = Depends(get_db)):
#    db_lot = models.ParkingLot(**lot.model_dump())
#    db.add(db_lot)
#    db.commit()
#    db.refresh(db_lot)
#    return db_lot

