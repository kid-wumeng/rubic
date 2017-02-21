_ = require('lodash')
MongoClient = require('mongodb').MongoClient
Store = require('../Store')
Error = require('../Error')



class DB



DB.connect = (config) ->
  name = Store.config.database.name
  user = Store.config.database.user
  pass = Store.config.database.pass
  host = Store.config.database.host ? '127.0.0.1'
  port = Store.config.database.port ? 27017
  auth = if user then "#{user}:#{pass}@" else ''
  # https://docs.mongodb.com/manual/reference/connection-string/
  url = "mongodb://#{auth}#{host}:#{port}/#{name}"
  return yield MongoClient.connect(url)



DB.find = (query) ->
  {table, schema} = query
  return Store.database.collection(table).findOne()



module.exports = DB