_ = require('lodash')
mongodb = require('mongodb')
Schema = require('./schema')



$db = null
$modelDict = {}



exports.init = (cfg) ->
  await @connect(cfg)
  await @ensureIDStore(cfg)
  await @ensureIndex(cfg)
  @createModelDict(cfg)



exports.connect = (cfg) ->
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
  $db = await mongodb.MongoClient.connect(url)



exports.ensureIDStore = (cfg) ->
  for name, {collection} of cfg.model
    # @TODO table -> collection
    idStore = await $db.collection('IDStore').findOne({table: collection})
    lastDoc = await $db.collection(collection).findOne({}, {
      sort: {id: -1}
      fields: {id: 1}
    })
    # @TODO 支持硬删除时的处理
    # idStore与集合都存在，核对最后的id是否一致
    if idStore and lastDoc
      if idStore.id isnt lastDoc.id
        throw "IDStore error: the 'id' of last document in <#{collection}> is not equal to idStore."
    # 仅idStore存在
    else if idStore
      throw "IDStore error: <#{collection}> is not found but idStore is existed."
    # 仅集合存在
    else if lastDoc
      throw "IDStore error: idStore of <#{collection}> is not found."



exports.ensureIndex = (cfg) ->
  for name, {collection} of cfg.model
    await $db.collection(collection).createIndex({id: 1}, {unique: true})



exports.createModelDict = (cfg) ->
  for name, define of cfg.model
    $modelDict[name] = @createModel(define)



exports.createModel = (define) ->
  model = {}
  model.collection = define.collection
  model.schema = @createSchema(define)
  model.findOne = (args...) => @findOne(model, args...)
  model.find = (args...) => @find(model, args...)
  model.count = (args...) => @count(model, args...)
  model.create = (args...) => @create(model, args...)
  model.update = (args...) => @update(model, args...)
  model.remove = (args...) => @remove(model, args...)
  model.restore = (args...) => @restore(model, args...)
  model.delete = (args...) => @delete(model, args...)
  return model



exports.createSchema = (define) ->
  schema = Schema.getSchema(define.schema)
  schema.id = {type: Number}
  schema.createDate = {type: Date}
  schema.updateDate = {type: Date}
  schema.removeDate = {type: Date}
  schema.restoreDate = {type: Date}
  return schema



exports.getModelDict = ->
  return $modelDict



# @RETURN {object/null}
exports.findOne = (model, query, opt) ->
  collection = model.collection
  schema = model.schema

  query = @formatQuery(query)
  opt = @formatQueryOpt(model, opt)

  data = await $db.collection(collection).findOne(query, opt)
  data = Schema.filter(schema, data)
  return data



# @RETURN {array[object]}
exports.find = (model, query, opt) ->
  collection = model.collection
  schema = model.schema

  query = @formatQuery(query)
  opt = @formatQueryOpt(model, opt)

  datas = await $db.collection(collection).find(query, opt).toArray()
  datas = datas.map (data) -> Schema.filter(schema, data)
  return datas



# @RETURN {number}
exports.count = (model, query, opt) ->
  collection = model.collection
  query = @formatQuery(query)
  opt = @formatQueryOpt(model, opt)
  return await $db.collection(collection).count(query, opt)



exports.create = (model, data) ->
  collection = model.collection
  schema = model.schema

  if not _.isPlainObject(data)
    throw "DB write error: @model('#{collection}').create(data), data should be an plain-object."

  data = Schema.filter(schema, data)
  Schema.check(schema, data)

  data.id = await @createID(collection)
  data.createDate = new Date()

  result = await $db.collection(collection).insertOne(data)
  return true
  # @TODO 支持model规则时再启动返回值（主要是为了private属性的处理）
  # return result.ops[0]



# @RETURN {object}
exports.update = (model, query, modifier) ->
  collection = model.collection
  schema = model.schema

  query = @formatQuery(query)
  modifier = @formatModifier(modifier)
  opt = {returnOriginal: false}
  result = await $db.collection(collection).findOneAndUpdate(query, modifier, opt)
  return true
  # @TODO 支持model规则时再启动返回值（主要是为了private属性的处理）
  # return result.value



exports.remove = (model, query) ->
  collection = model.collection

  query = @formatQuery(query)
  modifier = {
    $set: {removeDate: new Date()}
  }
  await $db.collection(collection).updateOne(query, modifier)
  return null



exports.restore = (model, query) ->
  collection = model.collection
  modifier = {
    $unset: {removeDate: ''}
    $set: {restoreDate: new Date()}
  }
  option = {returnOriginal: false}
  result = await $db.collection(collection).findOneAndUpdate(query, modifier, option)
  return true
  # @TODO 支持model规则时再启动返回值（主要是为了private属性的处理）
  # return result.value



exports.delete = (model, query) ->
  collection = model.collection
  await $db.collection(collection).deleteOne(query)
  return null



exports.createID = (collection) ->
  result = await $db.collection('IDStore').findOneAndUpdate({
    # @TODO table -> collection
    table: collection
  },{
    $inc:{id: 1}
  },{
    upsert: true
    returnOriginal: false
  })
  return result.value.id



exports.formatQuery = (query={}) ->
  query.removeDate = {$exists: false}
  return query



exports.formatQueryOpt = (model, opt={}) ->
  opt.page ?= 1
  opt.size ?= 0
  opt.skip = (opt.page - 1) * opt.size
  opt.limit = opt.size
  delete opt.page
  delete opt.size

  opt.fields ?= {}
  values = _.values(opt.fields)
  isOmit = (values.length is 0) or (values[0] is 0)
  if isOmit
    for key, rule of model.schema
      if rule.private
        opt.fields[key] = 0

  return opt



exports.formatModifier = (modifier={}) ->
  modifier.$set = {
    updateDate: new Date()
  }
  for key, value of modifier
    if key[0] isnt '$'
      modifier.$set[key] = value
      delete modifier[key]
  # @TODO 在$inc等修改器中也限制对id的修改（是否报错？）
  delete modifier.$set['id']
  return modifier