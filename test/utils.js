/*global require exports */
var superagent = require('superagent')
var queue = require('d3-queue').queue
var exec = require('child_process').exec
var pg = require('pg')
var putview = require('couchdb_put_view')
var should = require('should')


function delete_pgdb(config,db,delete_pgdb_cb){
    var host = config.postgresql.host || '127.0.0.1'
    var port = config.postgresql.port || 5432
    var adminuser =  'postgres'
    if(config.postgresql.admin !== undefined){
        if(config.postgresql.admin.user !== undefined){
            adminuser = config.postgresql.admin.user
        }
    }

    var commandline = ["/usr/bin/dropdb",
                       "-U", adminuser,
                       "-h", host,
                       "-p", port
                       , db
                      ].join(' ');
    console.log('deleting pgsql db ',db)

    exec(commandline
         ,function(e,out,err){
             if(e !== null ){
                 throw new Error(e)

             }
             return delete_pgdb_cb()
         })
    return null
}

function create_pgdb(config,db,create_pgdb_cb){
    var q = queue(1) // one after the other jobs
    var user = ''
    var host = config.postgresql.host || '127.0.0.1'
    var port = config.postgresql.port || 5432

    var admindb   = 'postgres'
    var adminuser = 'postgres'
    var admin_conn_string
    var conn_string

    if(config.postgresql.auth !== undefined &&
       config.postgresql.auth.username !== undefined){
        user = config.postgresql.auth.username
    }
    conn_string = "postgres://"+user+"@"+host+":"+port+"/"+db

    if(config.postgresql.admin !== undefined){
        if(config.postgresql.admin.db !== undefined){
            admindb = config.postgresql.admin.db
        }
        if(config.postgresql.admin.user !== undefined){
            adminuser = config.postgresql.admin.user
        }
    }
    admin_conn_string = "postgres://"+adminuser+"@"+host+":"+port+"/"+admindb

    config.postgresql.admin_conn_string = admin_conn_string
    config.postgresql.conn_string = conn_string

    // create the testing database
    q.defer(function(cb){
        pg.connect(admin_conn_string, function(err, client,clientdone) {
            if(err) {
                console.log( 'must have valid admin credentials in test.config.json, and a valid admin password setup in your .pgpass file' )
                throw new Error(err)
            }
            // create database
            var create_query = "create database " + db

            if(user != adminuser){
                create_query += " with owner " + user;
            }

            client.query(create_query,function(e,r){
                if(e){
                    console.log('failed: '+create_query)
                    console.log( {
                        'host_psql':host,
                        'port_psql':port,
                        'dbname_psql':db,
                        'admin database':admindb,
                        'admin user':adminuser
                    } )

                    throw new Error(e)
                }
                clientdone()
                // database successfully created

                return cb()
            })
        })
        return null
    })

    // create the necessary extensions in the created db
    q.defer(function(cb){
        var commandline = ["/usr/bin/psql",
                           "-d", db,
                           "-U", user,
                           "-h", host,
                           "-p", port,
                           "-c", '"CREATE EXTENSION postgis;"'
                          ].join(' ');
        exec(commandline
             ,function(e,out,err){

                 if(e !== null ){
                     console.log(e)
                     throw new Error(e)

                 }
                 return cb()
             })
        return null
    })

    q.defer(function(cb){
        var commandline = ["/usr/bin/psql",
                           "-d", db,
                           "-U", user,
                           "-h", host,
                           "-p", port,
                           "-f", 'test/files/wim.tables.schema_data.sql'].join(' ');
        console.log(commandline)
        exec(commandline
             ,function(e,out,err){
                 console.log(err)
                 if(e !== null ){
                     throw new Error(e)

                 }
                 return cb()
             })
        return null
    })

    q.defer(function(cb){
        var commandline = ["/usr/bin/psql",
                           "-d", db,
                           "-U", user,
                           "-h", host,
                           "-p", port,
                           "-f", 'test/files/wim.summ.speed.sql'].join(' ');
        console.log(commandline)
        exec(commandline
             ,function(e,out,err){
                 if(e !== null ){
                     throw new Error(e)

                 }
                 return cb()
             })
        return null
    })


    q.defer(function(cb){
        var commandline = ["/usr/bin/psql",
                           "-d", db,
                           "-U", user,
                           "-h", host,
                           "-p", port,
                           "-c", '"\\\copy wim_data from \''+process.cwd()+'/test/sql/some_wim_data.dump\' with (format binary);"'].join(' ');
        console.log(commandline)
        exec(commandline
             ,function(e,out,err){
                 console.log('done copying')
                 if(e !== null ){
                     throw new Error(e)

                 }
                 return cb()
             })
        return null
    })

    q.defer(function(cb){
        var commandline = ["/usr/bin/psql",
                           "-d", db,
                           "-U", user,
                           "-h", host,
                           "-p", port,
                           "-c", '"\\\copy wim_data from \''+process.cwd()+'/test/sql/some_more_wim_data.dump\' with (format binary);"'].join(' ');
        console.log(commandline)
        exec(commandline
             ,function(e,out,err){
                 console.log('done copying')
                 if(e !== null ){
                     throw new Error(e)

                 }
                 return cb()
             })
        return null
    })

    q.defer(function(cb){
        var commandline = ["/usr/bin/psql",
                           "-d", db,
                           "-U", user,
                           "-h", host,
                           "-p", port,
                           "-c", '"\\\copy wim.summaries_5min_speed from \''+process.cwd()+'/test/sql/some_wim_summaries_5min_speed.dump\' with (format binary);"'].join(' ');
        console.log(commandline)
        exec(commandline
             ,function(e,out,err){
                 console.log('done copying')
                 if(e !== null ){
                     throw new Error(e)

                 }
                 return cb()
             })
        return null
    })

    q.defer(function(cb){
        var commandline = ["/usr/bin/psql",
                           "-d", db,
                           "-U", user,
                           "-h", host,
                           "-p", port,
                           "-f", process.cwd()+
                           '/test/files/wim.tables.constraints.sql'
                          ].join(' ');
        console.log(commandline)
        exec(commandline
             ,function(e,out,err){
                 if(e !== null ){
                     throw new Error(e)

                 }
                 return cb()
             })
        return null
    })
    q.await(function(e){
        console.log('done with create pgdb')
        if(e){ throw new Error(e)}
        return create_pgdb_cb()
    })
    return null

}


exports.create_pgdb=create_pgdb
exports.delete_pgdb=delete_pgdb
