# deploy the result

```
james@emma calvad_wim_geometries[master]$ sqitch status
# On database spatialvds
No changes deployed
james@emma calvad_wim_geometries[master]$ sqitch deploy
Deploying changes to spatialvds
  + wim_geom .. 59892
59893
ok
james@emma calvad_wim_geometries[master]$ pg_prove -U slash -h activimetrics.com -d spatialvds test/wim_geom.sql
test/wim_geom.sql .. ok
All tests successful.
Files=1, Tests=17,  0 wallclock secs ( 0.02 usr +  0.00 sys =  0.02 CPU)
Result: PASS
james@emma calvad_wim_geometries[master]$
```
