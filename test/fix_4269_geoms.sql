SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
SELECT no_plan();
-- SELECT plan(1);

SELECT pass('Test fix_4269_geoms!');

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

-- expect that the metadata matches the stored 4269 geoms
SELECT results_eq(
    'build_geoms_4269',
    'existing_geoms_4269'
);

SELECT finish();
ROLLBACK;
