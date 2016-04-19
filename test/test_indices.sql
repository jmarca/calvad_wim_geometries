SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
--SELECT no_plan();
SELECT plan(6);

SELECT pass('Test indices');


-- are indexes set up?
SELECT indexes_are('public', 'wim_stations',
                   ARRAY['wim_stations_pkey'],'wim_stations has index' );
SELECT indexes_are('public', 'geom_points_4269',
                   ARRAY['geom_points_4269_pkey','geom_points_4269_geom_index'],
                   'geom_points_4269 has index' );
SELECT indexes_are('public', 'geom_points_4326',
                   ARRAY['geom_points_4326_pkey','geom_points_4326_geom_index'],
                   'geom_points_4326 has index' );
SELECT indexes_are('public', 'wim_points_4269' ,
                    ARRAY['wim_points_4269_pkey'],'wim_points_4269 has index' );
SELECT indexes_are('public', 'wim_points_4326' ,
                    ARRAY['wim_points_4326_pkey'],'wim_points_4326 has index' );


SELECT finish();
ROLLBACK;
