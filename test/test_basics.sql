SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
SELECT no_plan();
-- SELECT plan(1);

SELECT pass('Test tables and schemas');

SELECT has_schema('public','public schema exists');

-- is there a wim_stations table?
SELECT has_table('public', 'wim_stations', 'there is a wim_stations table');

-- are  there join tables?
SELECT has_table('public', 'wim_points_4269', 'there is a wim_points_4269 table');
SELECT has_table('public', 'wim_points_4326', 'there is a wim_points_4326 table');

-- are there geometry tables?
SELECT has_table('public', 'geom_points_4269','there is a geom_points_4269 table');
SELECT has_table('public', 'geom_points_4326','there is a geom_points_4326 table');


-- this one is going to fail
-- select tables_are(ARRAY['wim_stations'
--                        ,'wim_points_4269','wim_points_4326'
--                        ,'geom_points_4269','geom_points_4326'
--                        ],'expect exactly 5 tables;  this should fail');

SELECT finish();
ROLLBACK;
