_ = require('lodash')
DB = require('./DB')
Error = require('../Error')



class Query
  constructor: ({@table, @schema}) ->



###
  例子：
  whenDict = {
    'name': 'kid'
    'pet.age':
      $min: 3
      $max: 8
  }
###
Query.prototype.whenDict = {}



# 根据id排序，1是正序，-1是逆序
Query.prototype.valueSort = 1



# 为了使用方便，第一页是1而不是0
Query.prototype.valuePage = 1
# 0表示无限制
Query.prototype.valueSize = 0


# 由于pick与omit是互斥的（不能同时存在），所以设此标志位
# usePick = null 两者都没用到
# usePick = true 使用pick
# usePick = false 使用omit
Query.prototype.usePick = null

Query.prototype.pickSet = new Set()
Query.prototype.omitSet = new Set()



# 当前when对应的key，是个临时属性，仅用于收集条件
Query.prototype.whenKey = {}



Query.prototype.when = (key) ->
  @whenKey = key
  return @



Query.prototype.is = (value) ->
  _.set(@whenDict, @whenKey, value)
  return @



Query.prototype.sort = (valueSort) ->
  # @TODO 值检查
  @valueSort = valueSort
  return @



Query.prototype.page = (valuePage) ->
  # @TODO 值检查
  @valuePage = valuePage
  return @



Query.prototype.size = (valueSize) ->
  # @TODO 值检查
  @valueSize = valueSize
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