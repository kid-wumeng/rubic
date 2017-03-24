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
  model.findOne = (query, opt) => @findOne(model, query,  opt)
  model.find = (query, opt) => @find(model, query, opt)
  model.count = (query, opt) => @count(model, query, opt)
  model.create = (data) => @create(model, data)
  model.update = (query, modifier) => @update(model, query, modifier)
  model.updateMany = (query, modifier) => @updateMany(model, query, modifier)
  model.remove = (query) => @remove(model, query)
  model.restore = (query) => @restore(model, query)
  model.delete = (query) => @delete(model, query)
  model.aggregate = (pipeline, opt) => @aggregate(model, pipeline, opt)
  return model



exports.createSchema = (define) ->
  schema = Schema.getSchema(define.schema)
  schema.id = {type: Number}
  schema.createDate = {type: Date}
  schema.updateDate = {type: Date}
  schema.removeDate = {type: Date}
  schema.restoreDate = {type: Date}
  Schema.handleArrayRules(schema)
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

  if data
    data = Schema.filter(schema, data)
    if opt.join
      await @findOneJoin({model, data, opt})

  return data



# @RETURN {array[object]}
exports.find = (model, query, opt) ->
  collection = model.collection
  schema = model.schema

  query = @formatQuery(query)
  opt = @formatQueryOpt(model, opt)

  datas = await $db.collection(collection).find(query, opt).toArray()

  if datas.length
    datas = datas.map (data) ->
      Schema.filter(schema, data)
    if opt.join
      await @findJoin({model, datas, opt})

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
  # @TODO 支持model规则时（主要是为了private属性的处理）
  return result.ops[0]



# @RETURN {object}
exports.update = (model, query, modifier) ->
  collection = model.collection
  schema = model.schema

  query = @formatQuery(query)
  modifier = @formatModifier(modifier)

  opt = {returnOriginal: false}
  result = await $db.collection(collection).findOneAndUpdate(query, modifier, opt)

  # @TODO 支持model规则（主要是为了private属性的处理）
  return result.value



# @RETURN {Array[object]/null}
exports.updateMany = (model, query, modifier) ->
  collection = model.collection
  schema = model.schema

  query = @formatQuery(query)
  modifier = @formatModifier(modifier)

  await $db.collection(collection).updateMany(query, modifier)



exports.remove = (model, query) ->
  collection = model.collection

  if typeof(query) is 'number'
    query = {id: query}

  query = @formatQuery(query)
  modifier = {
    $set: {removeDate: new Date()}
  }
  await $db.collection(collection).updateOne(query, modifier)
  return null



exports.restore = (model, query) ->
  collection = model.collection

  if typeof(query) is 'number'
    query = {id: query}

  modifier = {
    $unset: {removeDate: ''}
    $set: {restoreDate: new Date()}
  }
  opt = {returnOriginal: false}
  result = await $db.collection(collection).findOneAndUpdate(query, modifier, opt)
  # @TODO 支持model规则（主要是为了private属性的处理）
  return result.value



exports.delete = (model, query) ->
  collection = model.collection

  if typeof(query) is 'number'
    query = {id: query}

  await $db.collection(collection).deleteOne(query)
  return null



exports.aggregate = (model, pipeline, opt) ->
  collection = model.collection
  return await $db.collection(collection).aggregate(pipeline, opt).toArray()



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
  if typeof(query) is 'number'
    query = {id: query}
  query = Object.assign({}, query)
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
    if key[0] is '$'
      if _.isPlainObject(value)
        modifier[key] = value
        delete modifier[key]['id']
    else
      modifier.$set[key] = value
      delete modifier[key]
  # @TODO 在$inc等修改器中也限制对id的修改（是否报错？）
  delete modifier.$set['id']
  return modifier



exports.findOneJoin = ({model, data, opt}) ->
  for key, fields of opt.join
    rule = model.schema[key]
    joinModel = $modelDict[rule.join]
    joinData = _.get(data, key)
    if Array.isArray(joinData)
      joinDatas = joinData
      joinIDs = joinDatas.map (data) -> data.id
      joinDatas = await @find(joinModel, {
        id: {$in: joinIDs}
      },{
        fields: @formatFields(fields)
      })
      _.set(data, key, joinDatas)
    else if _.isPlainObject(joinData)
      joinID = joinData.id
      joinData = await @findOne(joinModel, {
        id: joinID
      },{
        fields: @formatFields(fields)
      })
      _.set(data, key, joinData)



exports.findJoin = ({model, datas, opt}) ->
  ###
  @example
  cast = await @model.Book.find({}, {
    join:
      'author': 'name'
  })
  ###
  for key, fields of opt.join
    rule = model.schema[key]
    joinModel = $modelDict[rule.join]
    allIDs = []
    for data in datas
      joinData = _.get(data, key)
      if Array.isArray(joinData)
        joinDatas = joinData
        for joinData in joinDatas
          allIDs.push(joinData.id)
      else if _.isPlainObject(joinData)
        allIDs.push(joinData.id)
    allIDs = _.uniq(allIDs)
    joinDatas = await @find(joinModel, {
      id: {$in: allIDs}
    },{
      fields: @formatFields(fields)
    })
    joinDataDict = {}
    for joinData in joinDatas
      joinDataDict[joinData.id] = joinData
    # 分配到各data中
    for data in datas
      joinData = _.get(data, key)
      if Array.isArray(joinData)
        joinDatas = joinData
        joinDatas = joinDatas.map (joinData) -> joinDataDict[joinData.id]
        _.set(data, key, joinDatas)
      else if _.isPlainObject(joinData)
        joinData = joinDataDict[joinData.id]
        _.set(data, key, joinData)



exports.formatFields = (fields) ->
  if fields is true
    return {}
  fields = fields.split(/\s+/)
  fieldDict = {}
  isPick = false
  for field in fields
    if field[0] is '-'
      field = field.slice(1)
      fieldDict[field] = 0
    else
      isPick = true
      fieldDict[field] = 1
  if isPick
    fieldDict.id = 1
  return fieldDict