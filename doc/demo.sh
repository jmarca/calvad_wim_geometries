# demo sqitch

sqitch init calvad_wim_geometries --uri https://github.com/jmarca/calvad_wim_geometries --engine pg
createdb -U slash -h 127.0.0.1 brokendb
sqitch target add brokendb db:pg://slash@127.0.0.1/brokendb
sqitch engine add pg brokendb
sqitch add brooklyn  -m 'Hello Brooklyn!'
sqitch deploy
sqitch revert
sqitch deploy
psql brokendb

# look at the tables
\dt
\dn
\dt sqitch.
select * from sqitch.changes ;
select * from sqitch.dependencies ;
select * from sqitch.events ;
select * from sqitch.projects ;
select * from sqitch.releases ;
select * from sqitch.tags ;
\q
