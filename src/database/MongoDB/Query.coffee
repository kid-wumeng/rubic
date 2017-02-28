_ = require('lodash')
deepKeys = require('deep-keys')
Executor = require('./Executor')
Error = require('../../Error')



class Query
  constructor: ({@db, @tableName, @all}) ->



Query.prototype.db = null
Query.prototype.tableName = null
Query.prototype.all = false



###
  例子：
  treeQuery =
    name: 'kid'
    pet:
      age:
        $gte: 3
        $lte: 8
###
Query.prototype.treeQuery = {}



###
  例子：
  dictOption =
    sort:
      id: 1
    skip: 20
    limit: 5
    fields:
      name: 1
###
Query.prototype.dictOption = {}



###
  例子：
  dictModifier =
    $set:
      name: 'kid'
    $inc:
      age: 1
###
Query.prototype.dictModifier = {
  $set: {}
  $inc: {}
}



# 为了前端使用方便，首页从1开始，而不是0
Query.valuePage = 1
# 0代表无限制
Query.valueSize = 0



# 当前where对应的key，仅用于收集条件的临时值
Query.prototype.currentKey = null



###
  where方法有以下几种模式：
  1. where('id', 1)
  2. where({id: 1, name: 'kid'})
  3. where('id') 这种会触发currentKey
###
Query.prototype.where = (args...) ->
  if args.length is 2
    key = args[0]
    value = args[1]
    _.set(@treeQuery, key, value)
  else
    first = args[0]
    if _.isObject(first)
      Object.assign(@treeQuery, first)
    else if typeof(first) is 'string'
      @currentKey = first
  return @



Query.prototype.is = (value) ->
  _.set(@treeQuery, @currentKey, value)
  return @



Query.prototype.min = (value) ->
  _.set(@treeQuery, "#{@currentKey}.$gte", value)
  return @



Query.prototype.max = (value) ->
  _.set(@treeQuery, "#{@currentKey}.$lte", value)
  return @



###
  sort方法有以下几种模式：
  1. sort('id', 1)
  2. sort(1) 默认以id为排序键，相当于1
  排序值：1为正序，-1为逆序
###
Query.prototype.sort = (args...) ->
  if args.length is 2
    key = args[0]
    value = args[1]
  else
    key = 'id'
    value = args[0]
  if value isnt 1 and value isnt -1
    throw new Error.DATABASE_QUERY_OPTION_INVALID_SORT({key})
  _.set(@dictOption, "sort.#{key}", value)
  return @



Query.prototype.page = (valuePage) ->
  if valuePage < 1
    throw new Error.DATABASE_QUERY_OPTION_INVALID_PAGE()
  @valuePage = valuePage
  return @



Query.prototype.size = (valueSize) ->
  if valueSize < 0
    throw new Error.DATABASE_QUERY_OPTION_INVALID_SIZE()
  @valueSize = valueSize
  return @



Query.prototype.field = (string) ->
  fieldNames = string.split(/\s+/)
  for name in fieldNames
    if name[0] is '-'
      name = name.slice(1)
      _.set(@dictOption, "fields.#{name}", -1)
    else
      _.set(@dictOption, "fields.#{name}", 1)
  return @



###
  set方法有以下几种模式：
  1. set('id', 1)
  2. set({id: 1, name: 'kid'})
###
Query.prototype.set = (args...) ->
  if args.length is 2
    key = args[0]
    value = args[1]
    @dictModifier.$set[key] = value
  else
    first = args[0]
    if _.isObject(first)
      Object.assign(@dictModifier.$set, first)
  return @



###
  inc方法有以下几种模式：
  1. inc('id', 1)
  2. inc('id') 默认+1
  3. inc({id: 1, age: -3})
###
Query.prototype.inc = (args...) ->
  if args.length is 2
    key = args[0]
    value = args[1]
    @dictModifier.$inc[key] = value
  else
    first = args[0]
    if _.isObject(first)
      Object.assign(@dictModifier.$set, first)
    else if typeof(first) is 'number'
      @dictModifier.$inc[key] = 1
  return @



Query.prototype.fetch = () ->
  @format()
  executor = new Executor({db: @db, tableName: @tableName})
  if @all
    return executor.findAll(@treeQuery, @dictOption)
  else
    return executor.find(@treeQuery, @dictOption)



Query.prototype.update = () ->
  @format()
  executor = new Executor({db: @db, tableName: @tableName})
  return executor.update(@treeQuery, @dictModifier)



Query.prototype.remove = () ->
  @format()
  executor = new Executor({db: @db, tableName: @tableName})
  return executor.remove(@treeQuery)



Query.prototype.restore = () ->
  @format()
  executor = new Executor({db: @db, tableName: @tableName})
  return executor.restore(@treeQuery)



Query.prototype.delete = () ->
  @format()
  executor = new Executor({db: @db, tableName: @tableName})
  return executor.delete(@treeQuery)



Query.prototype.format = () ->
  @dictOption.skip = (@valuePage-1) * @valueSize
  @dictOption.limit = @valueSize
  # @TODO fields不能同时存在加减的检查



module.exports = Query