SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
SELECT no_plan();
-- SELECT plan(1);


SELECT pass('Test have a join for each station');

-- make sure join relations are all there
select results_eq(
    'select site_no from wim_stations order by site_no',
    'select wim_id from wim_points_4269 order by wim_id'
);

select results_eq(
    'select site_no from wim_stations order by site_no',
    'select wim_id from wim_points_4326 order by wim_id'
);


SELECT finish();
ROLLBACK;
