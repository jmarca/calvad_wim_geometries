-- Deploy calvad_wim_geometries:wim_geom to pg

-- the assumption is that the wim_stations table exists and that the
-- geometry metadata is correct.  If you don't have wim_stations
-- table, then you're out of luck.


BEGIN;


-- first, clear the decks
truncate wim_points_4269 cascade;

ALTER TABLE ONLY geom_points_4269
    DROP CONSTRAINT geom_points_4269_gid_fkey;

CREATE SEQUENCE geom_points_4269_gid_seq;

ALTER TABLE geom_points_4269
    ALTER COLUMN gid SET DEFAULT
    nextval('geom_points_4269_gid_seq');

ALTER SEQUENCE geom_points_4269_gid_seq OWNED BY geom_points_4269.gid;
select setval('geom_points_4269_gid_seq',nextval('geom_ids_gid_seq'));

-- try this

WITH create_geoms AS (
  SELECT site_no, ST_GeomFromEWKT('SRID=4269;POINT('||a.longitude||' '||a.latitude||')') as geom
  FROM wim_stations a
  ORDER BY site_no
),
distinct_geoms AS (
  select distinct geom from create_geoms
),
not_in_geoms_table AS (
  select a.geom
  from distinct_geoms a
  left outer join geom_points_4269 b on (a.geom=b.geom)
  where b.geom is null
),
inserted_geoms AS (
  INSERT INTO geom_points_4269 (geom)
  SELECT geom
  FROM not_in_geoms_table
    RETURNING geom,gid
),
toomany_geoms AS (
  select a.geom,min(a.gid) as gid
  from geom_points_4269 a
  join distinct_geoms b on (a.geom=b.geom)
  group by a.geom
),
wim_join_geoms AS (
  select a.site_no as wim_id,b.gid
  from create_geoms a
  join toomany_geoms b ON(a.geom = b.geom)
)
INSERT INTO wim_points_4269 (wim_id,gid)
SELECT * FROM wim_join_geoms order by wim_id;


-- now 4326 geometries

truncate wim_points_4326 cascade;
ALTER TABLE ONLY geom_points_4326
    DROP CONSTRAINT geom_points_4326_gid_fkey;
CREATE SEQUENCE geom_points_4326_gid_seq;
ALTER TABLE geom_points_4326
    ALTER COLUMN gid SET DEFAULT
    nextval('geom_points_4326_gid_seq');
ALTER SEQUENCE geom_points_4326_gid_seq OWNED BY geom_points_4326.gid;
select setval('geom_points_4326_gid_seq',nextval('geom_ids_gid_seq'));

-- here create_geoms isn't the same as above.  It is a transform of
-- the previously created 4269 geometries, because the metadata is in
-- SRID=4269 for the WIM sites
WITH create_geoms AS (
  SELECT a.site_no, ST_TRANSFORM(b.geom,4326) as geom
  FROM wim_stations a
  join wim_points_4269 on (site_no=wim_id)
  join geom_points_4269 b using (gid)
  ORDER BY site_no
),
distinct_geoms AS (
  select distinct geom from create_geoms
),
not_in_geoms_table AS (
  select a.geom
  from distinct_geoms a
  left outer join geom_points_4326 b on (a.geom=b.geom)
  where b.geom is null
),
inserted_geoms AS (
  INSERT INTO geom_points_4326 (geom)
  SELECT geom
  FROM not_in_geoms_table
    RETURNING geom,gid
),
toomany_geoms AS (
  select a.geom,min(a.gid) as gid
  from geom_points_4326 a
  join distinct_geoms b on (a.geom=b.geom)
  group by a.geom
),
wim_join_geoms AS (
  select a.site_no as wim_id,b.gid
  from create_geoms a
  join toomany_geoms b ON(a.geom = b.geom)
)
INSERT INTO wim_points_4326 (wim_id,gid)
SELECT * FROM wim_join_geoms order by wim_id;


COMMIT;
