# Part 1

# create a test database
./node_modules/.bin/mocha test/test_deploy.js --timeout 0

# note the db name, and search replace with broken below

sqitch target add broken db:pg://slash@127.0.0.1/broken
sqitch engine add pg broken

# Part 2


sqitch add fix_4269_geoms -m 'Fix metadata vs geom mismatch'

# show the edited file

# run it
# run the test


sqitch add fix_4326_geoms -m 'Fix reprojected geometry mismatch'

# Step 6 ish  show the test, test will fail

pg_prove -d wimbroken test/fix_4326_geoms.sql

# step 7, have edited the deploy,

# show deploy, run deploy

sqitch deploy

# test now passes

pg_prove -d wimbroken test/fix_4326_geoms.sql
