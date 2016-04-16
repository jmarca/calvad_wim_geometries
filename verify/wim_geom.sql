-- Verify calvad_wim_geometries:wim_geom on pg

BEGIN;

SELECT wim_id,gid
FROM wim_points_4269
 WHERE FALSE;

SELECT wim_id,gid
FROM wim_points_4326
 WHERE FALSE;


ROLLBACK;
