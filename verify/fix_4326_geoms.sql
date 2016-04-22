-- Verify calvad_wim_geometries:fix_4326_geoms on pg

BEGIN;

SELECT wim_id,gid
FROM wim_points_4326
 WHERE FALSE;

ROLLBACK;
