# Part 2

# create a test database
./node_modules/.bin/mocha test/test_deploy.js --timeout 0

# note the db name, and change below

sqitch target add brokendb db:pg://slash@127.0.0.1/wim8_22_43
sqitch engine add pg brokendb

sqitch add fix_4269_geoms -m 'Fix metadata vs geom mismatch'

show the edited file

run it
run the test


sqitch add fix_4326_geoms -m 'Fix reprojected geometry mismatch'
