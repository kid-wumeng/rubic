colors = require('colors')
MongoClient = require('mongodb').MongoClient
Error = require('../../Error')



class DB



DB.config = null
DB.conn = null



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
  @conn = await MongoClient.connect(url)



DB.makeID = (tableName) ->
  table = @conn.collection('IDStore')
  result = await table.findOneAndUpdate({
    table: tableName
  },{
    $inc:{id: 1}
  },{
    upsert: true
    returnOriginal: false
  })
  return result.value.id



DB.find = (tableName, query={}) ->
  table = @conn.collection(tableName)
  query.removeDate = {$exists: false}
  return await table.findOne(query)



DB.findAll = (tableName, query={}) ->
  table = @conn.collection(tableName)
  query.removeDate = {$exists: false}
  return await table.find(query).toArray()



DB.create = (tableName, data={}) ->
  id = await @makeID(tableName)
  data.id = id
  data.createDate = Date.now()
  table = @conn.collection(tableName)
  result = await table.insertOne(data)
  return result.ops[0]



# data是诸如{$set:{}, $inc:{}}的形式
DB.update = (tableName, query, data={}) ->
  table = @conn.collection(tableName)
  data.$set = data.$set ? {}
  data.$set.updateDate = new Date()
  result = await table.findOneAndUpdate(query, data, {
    returnOriginal: false
  })
  return result.value



DB.remove = (tableName, query) ->
  table = @conn.collection(tableName)
  data =
    $set:
      removeDate: new Date()
  await table.updateOne(query, data)
  return null



DB.restore = (tableName, query) ->
  table = @conn.collection(tableName)
  data =
    $unset:
      removeDate: ''
    $set:
      restoreDate: new Date()
  result = await table.findOneAndUpdate(query, data, {
    returnOriginal: false
  })
  return result.value



DB.delete = (tableName, query) ->
  table = @conn.collection(tableName)
  await table.deleteOne(query)
  return null



module.exports = DB