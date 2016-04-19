SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
--SELECT no_plan();
SELECT plan(2);

SELECT pass('Test tables are exactly');

-- this one is going to fail
select tables_are(ARRAY['wim_stations'
                       ,'wim_points_4269','wim_points_4326'
                       ,'geom_points_4269','geom_points_4326'
                       ],'expect exactly 5 tables;  this should fail');

SELECT finish();
ROLLBACK;
