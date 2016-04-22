-- Verify calvad_wim_geometries:fix_4269_geoms on pg

BEGIN;


SELECT wim_id,gid
FROM wim_points_4269
 WHERE FALSE;


ROLLBACK;
