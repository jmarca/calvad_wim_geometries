SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
--SELECT no_plan();
SELECT plan(3);

SELECT pass('Test geometry vs metadata');


-- do the geometries actually match the metadata in all cases?
PREPARE build_geoms_4269 AS
  SELECT ST_GeomFromEWKT('SRID=4269;POINT('||a.longitude||' '||a.latitude||')')
  FROM wim_stations a
  ORDER BY site_no;

PREPARE existing_geoms_4269 AS
  SELECT b.geom
  FROM wim_points_4269 a
  JOIN geom_points_4269 b USING (gid)
  ORDER BY wim_id;

PREPARE projected_geoms_4269_to_4326 AS
  SELECT ST_TRANSFORM(b.geom,4326)
  FROM wim_points_4269 a
  JOIN geom_points_4269 b USING (gid)
  ORDER BY wim_id;

PREPARE existing_geoms_4326 AS
  SELECT b.geom
  FROM wim_points_4326 a
  JOIN geom_points_4326 b USING (gid)
  ORDER BY wim_id;


-- expect that the metadata matches the stored 4269 geoms
SELECT results_eq(
    'build_geoms_4269',
    'existing_geoms_4269'
);

--expect that the transformed 4269 geoms matches the stored 4326 geoms
SELECT results_eq(
    'projected_geoms_4269_to_4326',
    'existing_geoms_4326'
);



SELECT finish();
ROLLBACK;
