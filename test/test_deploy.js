/*eslint-env node, mocha */


var spawn = require('child_process').spawn
var fs = require('fs')

var queue = require('d3-queue').queue

var logfile = 'log/testwimimpute.log'

var utils=require('./utils.js')

var path = require('path')
var rootdir = path.normalize(process.cwd())
var config = {}
var config_file = rootdir+'/test.config.json'
var config_okay = require('config_okay')

var should = require('should')


before(function(done){

    var date = new Date()
    var test_pg_db_unique = 'wim'+date.getHours()+'_'+date.getMinutes()+'_'+date.getSeconds()

    config_okay(config_file,function(err,c){
        var q
        if(err){
            throw new Error('node.js needs a good croak module')
        }
        config = Object.assign(config,c)
        config.postgresql.db=test_pg_db_unique
        q = queue() // parallel jobs
        // pgsql
        q.defer(utils.create_pgdb,config,config.postgresql.db)
        // job 3 is write out temporary config file
        q.await(function(e,r1,r2,r3){
            should.not.exist(e)
            return done()
        })
        return null
    })
    return null
})


after(function(done){
    //var q = queue()
    console.log('cleaning after test_wim_impute...dropping temp databases')
    //q.defer(utils.delete_pgdb,config,config.postgresql.db)

    //q.defer(fs.unlink,path.normalize(process.cwd()+'/'+logfile))
    // q.awaitAll(function(e,r){
    //     return done()
    // })

    return done()
})


describe('fixing a broken database',function(){
    it('should work')
})
//        function(done){
//            var logstream,errstream,job

//            // should put all the pg_prove opts here consistent with
//            // config.postgresql
//            var commandline = ['-d',config.postgresql.db,'./wim_geom.sql']
//            logstream = fs.createWriteStream(logfile
//                                             ,{flags: 'a'
//                                               ,encoding: 'utf8'
//                                               ,mode: 0o666 })
//            errstream = fs.createWriteStream(logfile
//                                             ,{flags: 'a'
//                                               ,encoding: 'utf8'
//                                               ,mode: 0o666 })

//            job  = spawn('pg_prove', commandline)


//            job.stderr.setEncoding('utf8')
//            job.stdout.setEncoding('utf8')
//            job.stdout.pipe(logstream)
//            job.stderr.pipe(errstream)


//            job.on('exit',function(code){
//                var testq = queue()
//                testq.defer(function(cb){
//                    fs.readFile(logfile,{'encoding':'utf8'},function(err,data){
//                        // work through each line, parse the output
//                        var lines = data.split(/\r?\n/)
//                        console.log(lines)
//                        var pushed = {}
//                        var push_match = new RegExp('^push site:\\s+(.*)')
//                        lines.forEach(function(line){
//                            var p = push_match.exec(line)
//                            if(p && p[1]){
//                                pushed[p[1]] = 1
//                            }
//                        })
//                        return cb()
//                    })
//                    return null
//                })

//                testq.await(function(e,r){
//                    return done(e)
//                })
//            })
//            return null
//        })
//     return null
// })
