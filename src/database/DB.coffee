_ = require('lodash')
MongoClient = require('mongodb').MongoClient
Error = require('../Error')



class DB



DB.database = null



DB.connect = (op) ->
  name = op.name
  user = op.user
  pass = op.pass
  host = op.host ? '127.0.0.1'
  port = op.port ? 27017
  auth = if user then "#{user}:#{pass}@" else ''
  # https://docs.mongodb.com/manual/reference/connection-string/
  url = "mongodb://#{auth}#{host}:#{port}/#{name}"
  @database = yield MongoClient.connect(url)



DB.formatQueryDocument = (query) ->
  doc = {}
  for key, value of query.whenDict
    _.set(doc, key, value)
  return doc



DB.formatQueryOption = (query) ->
  sort = query.valueSort
  page = query.valuePage
  size = query.valueSize
  op = {}
  op.sort = {id: sort}
  op.skip = (page-1) * size
  op.limit = size
  op.fields = @formatQueryOptionFields(query)
  return op



DB.formatQueryOptionFields = (query) ->
  fields = {}
  # 挑选字段
  if query.usePick is true
    query.pickSet.forEach (value, key) ->
      fields[key] = 1
    fields['id'] = 1  # 默认包含id
  # 排除字段
  if query.usePick is false
    query.omitSet.forEach (value, key) ->
      fields[key] = -1
  return fields



DB.find = (query) ->
  doc = @formatQueryDocument(query)
  op = @formatQueryOption(query)
  return @database.collection(table).findOne(doc, op)



DB.findAll = (query) ->
  {table, schema} = query
  doc = @formatQueryDocument(query)
  op = @formatQueryOption(query)
  return @database.collection(table).find(doc, op).toArray()



module.exports = DB