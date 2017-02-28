colors = require('colors')
MongoClient = require('mongodb').MongoClient
Table = require('./Table')
Error = require('../../Error')



class DB



DB.config = null
DB.db = null



DB.connect = (config) ->
  @config = config
  name = config.name
  user = config.user
  pass = config.pass
  host = config.host ? '127.0.0.1'
  port = config.port ? 27017
  auth = if user then "#{user}:#{pass}@" else ''
  # 格式说明参考：https://docs.mongodb.com/manual/reference/connection-string/
  url = "mongodb://#{auth}#{host}:#{port}/#{name}"
  @db = await MongoClient.connect(url)



DB.table = (tableName) ->
  return new Table({db: @db, tableName})



module.exports = DB