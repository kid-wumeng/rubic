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
  return Store.database.collection(table).findOne(doc, op)



DB.findAll = (query) ->
  {table, schema} = query
  doc = @formatQueryDocument(query)
  op = @formatQueryOption(query)
  return Store.database.collection(table).find(doc, op).toArray()



module.exports = DB