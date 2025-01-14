# Assignment 02: PostGIS Analytics

**Due: Oct 11, 2021 by 11:59pm ET**

## Submission Instructions

1. Fork this repository to your GitHub account.

2. Write a query to answer each of the questions below. Your queries should produce results in the format specified. Write your query in a SQL file corresponding to the question number (e.g. a file named _query06.sql_ for the answer to question #6). Each SQL file should contain a single `SELECT` query (though it may include other queries before the select if you need to do things like create indexes or update columns). Some questions include a request for you to discuss your methods. Update this README file with your answers in the appropriate place.

3. There are several datasets that are prescribed for you to use in this assignment. Your datasets should be named:
  * septa_bus_stops ([SEPTA GTFS](http://www3.septa.org/developer/))
  * septa_bus_shapes ([SEPTA GTFS](http://www3.septa.org/developer/))
  * septa_rail_stops ([SEPTA GTFS](http://www3.septa.org/developer/))
  * phl_pwd_parcels ([OpenDataPhilly](https://opendataphilly.org/dataset/pwd-stormwater-billing-parcels))
  * census_block_groups ([OpenDataPhilly](https://opendataphilly.org/dataset/census-block-groups))
  * census_population ([Census Explorer](https://data.census.gov/cedsci/table?t=Populations%20and%20People&g=0500000US42101%241500000&y=2010&d=DEC%20Summary%20File%201&tid=DECENNIALSF12010.P1))

4. Submit a pull request with your answers. You can continue to push changes to your repository up until the due date, and those changes will be visible in your pull request.

**Note, I take logic for solving problems into account when grading. When in doubt, write your thinking for solving the problem even if you aren't able to get a full response.**

## Questions

1. Which bus stop has the largest population within 800 meters? As a rough estimation, consider any block group that intersects the buffer as being part of the 800 meter buffer.  
  
**Answer:**  
![image](https://user-images.githubusercontent.com/90301308/137847250-0ef8a233-fc9a-43e8-9b9a-783186183df6.png)


2. Which bus stop has the smallest population within 800 meters?

  **The queries to #1 & #2 should generate relations with a single row, with the following structure:**

  ```sql
  (
      stop_name text, -- The name of the station
      estimated_pop_800m integer, -- The population within 800 meters
      the_geom geometry(Point, 4326) -- The geometry of the bus stop
  )
  ```
    
**Answer:**   
![image](https://user-images.githubusercontent.com/90301308/137847325-83ba70d4-4ff9-4bd8-b9f3-9471ea4db346.png)


3. Using the Philadelphia Water Department Stormwater Billing Parcels dataset, pair each parcel with its closest bus stop. The final result should give the parcel address, bus stop name, and distance apart in meters. Order by distance (largest on top).

  **Structure:**
  ```sql
  (
      address text,  -- The address of the parcel
      stop_name text,  -- The name of the bus stop
      distance_m double precision  -- The distance apart in meters
  )
  ```
    
**Answer**  



4. Using the _shapes.txt_ file from GTFS bus feed, find the **two** routes with the longest trips. In the final query, give the `trip_headsign` that corresponds to the `shape_id` of this route and the length of the trip.

  **Structure:**
  ```sql
  (
      trip_headsign text,  -- Headsign of the trip
      trip_length double precision  -- Length of the trip in meters
  )
  ```
    
**Answer:**   
![image](https://user-images.githubusercontent.com/90301308/137847829-744b05c6-6cf0-4165-8341-bbcf9c908865.png)



5. Rate neighborhoods by their bus stop accessibility for wheelchairs. Use Azavea's neighborhood dataset from OpenDataPhilly along with an appropriate dataset from the Septa GTFS bus feed. Use the [GTFS documentation](https://gtfs.org/reference/static/) for help. Use some creativity in the metric you devise in rating neighborhoods. Describe your accessibility metric:

  **Description:**  
  First, I define that any stops intersecting neighborhoods' 500m buffer will be considered as amenities to that neighborhood. Then rate accessibility by the wheelchair-friendly stop percentage, which is the amount of stops with wheelchair boarding in that neighborhood devided by the amount of all stops contributing to that neighborhood. When the the first metric, wheelchair-friendly stop percentage, is the same, I will apply the amount of stops with wheelchair boarding in that neighborhood as the second metric.
  
  
6. What are the _top five_ neighborhoods according to your accessibility metric?  
  
**Answer**   
![image](https://user-images.githubusercontent.com/90301308/137847103-f8e9af20-95f0-49e6-b8c8-55dbffea729e.png)


7. What are the _bottom five_ neighborhoods according to your accessibility metric?

  **Both #6 and #7 should have the structure:**
  ```sql
  (
    neighborhood_name text,  -- The name of the neighborhood
    accessibility_metric ...,  -- Your accessibility metric value
    num_bus_stops_accessible integer,
    num_bus_stops_inaccessible integer
  )
  ```
    
**Answer**   
![image](https://user-images.githubusercontent.com/90301308/137847148-0d2ca8e4-e6ed-4885-970d-44a5b77fb772.png)


8. With a query, find out how many census block groups Penn's main campus fully contains. Discuss which dataset you chose for defining Penn's campus.

  **Structure (should be a single value):**
  ```sql
  (
      count_block_groups integer
  )
  ```

**Description:**  
  I downloaded universities_colleges (GeoJSON) from OpenDataPhilly, which contains all the buildings belonging to universities in Philly. The URL is https://opendata.arcgis.com/api/v3/datasets/8ad76bc179cf44bd9b1c23d6f66f57d1_0/downloads/data?format=geojson&spatialRefId=4326
  
  
  
**Answer:**   
count_block_groups   
10   


9. With a query involving PWD parcels and census block groups, find the `geo_id` of the block group that contains Meyerson Hall. ST_MakePoint() and functions like that are not allowed.

  **Structure (should be a single value):**
  ```sql
  (
      geo_id text
  )
  ```
    
**Answer:**   
geo_id   
421010369001  


10. You're tasked with giving more contextual information to rail stops to fill the `stop_desc` field in a GTFS feed. Using any of the data sets above, PostGIS functions (e.g., `ST_Distance`, `ST_Azimuth`, etc.), and PostgreSQL string functions, build a description (alias as `stop_desc`) for each stop. Feel free to supplement with other datasets (must provide link to data used so it's reproducible), and other methods of describing the relationships. PostgreSQL's `CASE` statements may be helpful for some operations.

  **Structure:**
  ```sql
  (
      stop_id integer,
      stop_name text,
      stop_desc text,
      stop_lon double precision,
      stop_lat double precision
  )
  ```
    
**Answer**  
![image](https://user-images.githubusercontent.com/90301308/137842845-51dfe359-1c53-4287-af6d-2c611109cec9.png)



  As an example, your `stop_desc` for a station stop may be something like "37 meters NE of 1234 Market St" (that's only an example, feel free to be creative, silly, descriptive, etc.)

  **Tip when experimenting:** Use subqueries to limit your query to just a few rows to keep query times faster. Once your query is giving you answers you want, scale it up. E.g., instead of `FROM tablename`, use `FROM (SELECT * FROM tablename limit 10) as t`.
