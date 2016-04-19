-- Deploy calvad_wim_geometries:fix_4326_geoms to pg

BEGIN;


-- first, clear the decks
drop table  wim_points_4326;

-- recreate without any FK to geom_points
CREATE TABLE wim_points_4326 (
    gid integer NOT NULL,
    wim_id integer NOT NULL  primary key REFERENCES wim_stations (site_no)   ON DELETE CASCADE
);

-- get rid of gid relationship in geom_points
ALTER TABLE ONLY geom_points_4326
    DROP CONSTRAINT geom_points_4326_gid_fkey;
CREATE SEQUENCE geom_points_4326_gid_seq;
ALTER TABLE geom_points_4326
    ALTER COLUMN gid SET DEFAULT
    nextval('geom_points_4326_gid_seq');
ALTER SEQUENCE geom_points_4326_gid_seq OWNED BY geom_points_4326.gid;
SELECT setval('geom_points_4326_gid_seq',nextval('geom_ids_gid_seq'));

-- fix the broken 4236 geometries

-- here create_geoms isn't the same 4269.  It is a transform of
-- the previously created 4269 geometries, because the metadata is in
-- SRID=4269 for the WIM sites

-- create geoms holds geometries created from the metadata
WITH create_geoms AS (
  SELECT a.site_no, ST_TRANSFORM(b.geom,4326) as geom
  FROM wim_stations a
  join wim_points_4269 on (site_no=wim_id)
  join geom_points_4269 b using (gid)
  ORDER BY site_no
),

-- some of the geoms are likely repeated.  only make one
distinct_geoms AS (
  select distinct geom from create_geoms
),

-- Only keep those points that are not already in the
-- geom_points_4326 table
not_in_geoms_table AS (
  select a.geom
  from distinct_geoms a
  left outer join geom_points_4326 b on (a.geom=b.geom)
  where b.geom is null
),

-- insert the new geometries
inserted_geoms AS (
  INSERT INTO geom_points_4326 (geom)
  SELECT geom
  FROM not_in_geoms_table
    RETURNING geom,gid
),

-- combine both new and old for pairing off in join table
new_and_old as (
  select a.geom,a.gid
  from geom_points_4326 a
  join distinct_geoms b on (a.geom=b.geom)
  union
  select aa.geom,aa.gid
  from inserted_geoms aa
  join distinct_geoms b on (aa.geom=b.geom)
),

-- there is no guarantee that geometries in
-- geom_points_4326 are unique
-- so reduce new_and_old using DISTINCT
unique_set as (
  select distinct min(gid) as gid,geom
  from new_and_old
  group by geom
),

-- finally, join wim site numbers with the newly created gid values by
-- joining the tables on geom.  I expect multiple gids might occur
-- here.
wim_join_geoms AS (
  select a.site_no as wim_id,b.gid
  from create_geoms a
  join unique_set b ON(a.geom = b.geom)
)
INSERT INTO wim_points_4326 (wim_id,gid)
SELECT * FROM wim_join_geoms order by wim_id;


-- now that the geometries are paired off, reinstate the fk constraint
ALTER TABLE ONLY wim_points_4326
    ADD CONSTRAINT wim_points_4326_gid_fkey FOREIGN KEY (gid)
        REFERENCES geom_points_4326(gid)
    ON DELETE CASCADE;

COMMIT;
