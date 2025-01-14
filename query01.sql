/*
  Which bus stop has the largest population within 800 meters? As a rough
  estimation, consider any block group that intersects the buffer as being part
  of the 800 meter buffer.
*/

-- create a geometry column with longitude and latitude for septa_bus_stops
alter table septa_bus_stops
    add column if not exists geometry geometry(Point, 4326);

update septa_bus_stops
  set geometry = ST_SetSRID(ST_MakePoint(stop_lon, stop_lat), 4326);

-- create a geometry index
create index if not exists septa_bus_stops__the_geom__32129__idx
    on septa_bus_stops
    using GiST (ST_Transform(geometry, 32129));

-- combine bus stops with its block groups
with septa_bus_stop_block_groups as (
    select
        s.stop_id,
        '1500000US' || bg.geoid10 as id
    from septa_bus_stops as s
    join census_block_groups as bg
        on ST_DWithin(
            ST_Transform(s.geometry, 32129),
            ST_Transform(bg.geometry, 32129),
            800
        )
),
-- sum surrounding population of each bus stop
septa_bus_stop_surrounding_population as (
    select
        stop_id,
        sum(total) as estimated_pop_800m
    from septa_bus_stop_block_groups as s
    join census_population as p using (id)
    group by stop_id
)
-- select the bus stop with largest population and output
select
    stop_name,
    estimated_pop_800m::integer,
    geometry
from septa_bus_stop_surrounding_population
join septa_bus_stops using (stop_id)
order by estimated_pop_800m desc
limit 1;
