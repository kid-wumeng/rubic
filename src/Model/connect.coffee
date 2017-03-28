mongodb = require('mongodb')


module.exports = (cfg) ->

  name = cfg.database.name
  user = cfg.database.user
  pass = cfg.database.pass
  host = cfg.database.host ? '127.0.0.1'
  port = cfg.database.port ? 27017

  if user
    auth = "#{user}:#{pass}@"
  else
    auth = ''

  # url格式参考：https://docs.mongodb.com/manual/reference/connection-string/
  url = "mongodb://#{auth}#{host}:#{port}/#{name}"
  @db = await mongodb.MongoClient.connect(url)