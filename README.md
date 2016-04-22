# Make or fix WIM geometries

This repo exists to make (or fix) WIM site geometries in a
PostgreSQL/PostGIS database.

It turns out that for historical reasons, the WIM-Geometry join table
can break, and fixing the point geometry table is not possible.

This repo has tests to check that the WIM site geometries are
consistent with the WIM site metadata.

Run the tests.  If there are problems, run the code.

# pgTAP and Sqitch

This repo makes use of the excellent pgTAP and Sqitch tools.  Go the
the website [pgTAP](http://pgtap.org/) to install pgTAP, and to the
site [Sqitch](http://sqitch.org/) to figure out how to install Sqitch.

# Tests

pgTAP will install the tool pg_prove.

Run the test by doing:

```
pg_prove -d [mydb] test/*.sql
```

If the tests pass, then you are fine, no worries, go do something
else.

If the tests fail, then that means that one or more of the WIM
position information (latitude and longitude) in the WIM metadata
table does not reflect the latitude and longitude of the PostGIS point
geometry associated with that site according to the join table.

If that is the case, then you need to move on to the next step to fix
things.

# Fixing things

The next step can actually be run regardless of whether the geometry
data is consistent with the metadata or not.  It will truncate the
join tables, break all the foreign key constraints,  build new
point geometry tables (SRID 4269 and SRID 4326), and re-establish the
join tables and foreign key constraints.

```
sqitch deploy
```

# Re-test

If sqitch deploys without issues, then re-run the tests to make sure
all is well

```
pg_prove -d [mydb] test/*.sql
```

# Issues

If sqitch deploy fails for some reason, something is wrong.

# Details

The assumption is that the metadata is correct, and that either you
want to redo or create anew the geometry tables.

So, the tests make sure that the tables exist, that they link to each
other via foreign key constraints, and finally that the geometries are
consistent with the stored metadata.  If the tests pass, there are no
problems with the data.  If the tests do not pass, then you need to
run the sqitch code to fix the geometries.


# License

released under GPL-v2
