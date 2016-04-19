SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
SELECT no_plan();
-- SELECT plan(1);

SELECT pass('Test wim_geom!');

-- is there a wim_stations table?
SELECT has_table('public', 'wim_stations', 'there is a wim_stations table');

-- are  there join tables?
SELECT has_table('public', 'wim_points_4269', 'there is a wim_points_4269 table');
SELECT has_table('public', 'wim_points_4326', 'there is a wim_points_4326 table');

-- are there geometry tables?
SELECT has_table('public', 'geom_points_4269','there is a geom_points_4269 table');
SELECT has_table('public', 'geom_points_4326','there is a geom_points_4326 table');

-- are primary keys set up?
SELECT col_is_pk('public', 'wim_stations', 'site_no', 'wim stations site_no is pk' );
SELECT col_is_pk('public', 'geom_points_4269','gid', 'geom points 4269 gid is pk' );
SELECT col_is_pk('public', 'geom_points_4326','gid', 'geom points 4326 gid is pk' );

SELECT col_is_pk('public', 'wim_points_4326','wim_id', 'geom points 4326 gid is pk' );
SELECT col_is_pk('public', 'wim_points_4269','wim_id', 'geom points 4269 gid is pk' );


-- -- are indexes set up?
-- SELECT indexes_are('public', 'wim_stations', 'site_no',ARRAY[:indexes], 'wim_stations has index' );
-- SELECT indexes_are('public', 'geom_points_4269','gid',  ARRAY[:indexes],'geom_points_4269 has index' );
-- SELECT indexes_are('public', 'geom_points_4326','gid',  ARRAY[:indexes],'geom_points_4326 has index' );
-- SELECT indexes_are('public', 'wim_points_4269' ,'gid',  ARRAY[:indexes],'wim_points_4269 has index' );
-- SELECT indexes_are('public', 'wim_points_4326' ,'gid',  ARRAY[:indexes],'wim_points_4326 has index' );


-- the geom_ids table was an idea to solve a problem I no longer have,
-- and I'm abandoning it for the future

SELECT fk_ok(
    'public','wim_points_4269','wim_id',
    'public','wim_stations','site_no',
    'wim_points_4269 connects to wim_stations'
);
SELECT fk_ok(
    'public','wim_points_4269','gid',
    'public','geom_points_4269','gid',
    'wim_points_4269 connects to geom_points_4269'
);


SELECT fk_ok(
    'public','wim_points_4326','wim_id',
    'public','wim_stations','site_no',
    'wim_points_4326 connects to wim_stations'
);
SELECT fk_ok(
    'public','wim_points_4326','gid',
    'public','geom_points_4326','gid',
    'wim_points_4326 connects to geom_points_4326'
);

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


-- make sure join relations are all there
select results_eq(
    'select count(*) from wim_stations',
    'select count(*) from wim_points_4326'
);

select results_eq(
    'select count(*) from wim_stations',
    'select count(*) from wim_points_4269'
);

-- that just about covers it, sportsfans

SELECT finish();
ROLLBACK;
