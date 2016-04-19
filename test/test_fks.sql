SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
--SELECT no_plan();
SELECT plan(5);

SELECT pass('Test foreign key relationships');


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


SELECT finish();
ROLLBACK;
