# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.

import psycopg2
import pandas as pd
import geopandas as gpd
from shapely import wkt

def main():
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        dbname="cclemente",
        user="cclemente",
        password="Parker123",
        host="localhost",
        port="5431"
    )
    cur = conn.cursor()

    # Load CSV
    city_data = pd.read_csv("modified_city_data.csv")

    # Convert geometry from WKT
    city_data["geo_street_seg"] = city_data["the_geom"].apply(wkt.loads)
    gdf = gpd.GeoDataFrame(city_data, geometry="geo_street_seg", crs="EPSG:4326")

    # Project to meters for accurate centroid calculation
    gdf = gdf.to_crs(epsg=3857)
    gdf['centroid'] = gdf.geometry.centroid

    # Convert centroids back to lat/lng
    gdf['centroid_wgs84'] = gdf['centroid'].to_crs(epsg=4326)
    gdf['latitude'] = gdf['centroid_wgs84'].y
    gdf['longitude'] = gdf['centroid_wgs84'].x

    # Loop through rows
    for index, row in gdf.iterrows():
        block_id = row['PHYSICALID']
        #zip_code = row['L_ZIP']
        borough = row['Borough Code']
        street_name = row['Full Street Name']
        lat = row['latitude']
        lng = row['longitude']

        if pd.notnull(lat) and pd.notnull(lng):
            cur.execute("""
                INSERT INTO public.blocks (id, borough, street_name, latitude, longitude)
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (id) DO UPDATE SET
                    borough = EXCLUDED.borough,
                                        street_name = EXCLUDED.street_name,
                    latitude = EXCLUDED.latitude,
                    longitude = EXCLUDED.longitude;
            """, (block_id, borough, street_name, lat, lng))
        else:
            print(f"Skipping row {index} (PHYSICALID={block_id}) due to missing lat/lng.")

    # Commit changes and close
    conn.commit()
    cur.close()
    conn.close()
    print("Database updated successfully.")

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
