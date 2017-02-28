_ = require('lodash')
DB = require('./DB')
Error = require('../Error')



class Query
  constructor: ({@table, @schema}) ->



###
  例子：
  dictWhere = {
    'name': 'kid'
    'pet.age':
      $min: 3
      $max: 8
  }
###
Query.prototype.dictWhere = {}



Query.prototype.option =
  # 根据_id排序，1是正序，-1是逆序
  sort: 1
  # 为了使用方便，第一页是1而不是0
  page: 1
  # 0表示无限制
  size: 0


# 由于pick与omit是互斥的（不能同时存在），所以设此标志位
# usePick = null 两者都没用到
# usePick = true 使用pick
# usePick = false 使用omit
Query.prototype.usePick = null

Query.prototype.pickSet = new Set()
Query.prototype.omitSet = new Set()



# 当前when对应的key，是个临时属性，仅用于收集条件
Query.prototype.key = {}



Query.prototype.when = (key) ->
  @key = key
  return @



Query.prototype.is = (value) ->
  _.set(@doc, @key, value)
  return @



Query.prototype.sort = (sort) ->
  # @TODO 值检查
  @option.sort = sort
  return @



Query.prototype.page = (page) ->
  # @TODO 值检查
  @option.page = page
  return @



Query.prototype.size = (valueSize) ->
  # @TODO 值检查
  @option.size = valueSize
  return @



###
{String} keys
###
Query.prototype.pick = (keys) ->
  @usePick = true
  keys = keys.split(/\s+/)
  for key in keys
    @pickSet.add(key)
  return @



###
{String} keys
###
Query.prototype.omit = (keys) ->
  @usePick = false
  keys = keys.split(/\s+/)
  for key in keys
    @omitSet.add(key)
  return @



Query.prototype.find = () ->
  return DB.find(@)



Query.prototype.findAll = () ->
  return DB.findAll(@)



module.exports = Query