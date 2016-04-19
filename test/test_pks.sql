SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
--SELECT no_plan();
SELECT plan(6);

SELECT pass('Test table primary keys');

-- are primary keys set up?
SELECT col_is_pk('public', 'wim_stations', 'site_no', 'wim stations site_no is pk' );
SELECT col_is_pk('public', 'geom_points_4269','gid', 'geom points 4269 gid is pk' );
SELECT col_is_pk('public', 'geom_points_4326','gid', 'geom points 4326 gid is pk' );

SELECT col_is_pk('public', 'wim_points_4326','wim_id', 'geom points 4326 gid is pk' );
SELECT col_is_pk('public', 'wim_points_4269','wim_id', 'geom points 4269 gid is pk' );



SELECT finish();
ROLLBACK;
