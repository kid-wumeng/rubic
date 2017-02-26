_ = require('lodash')
Error = require('../Error')



class DataChecker
# @TODO String 计数算法
# @TODO Buffer mimes



# 规则集
# $default {Boolean}   默认值，设置为null或undefined是没意义的
# $require {Boolean}   必要性
# $type    {Object}    可选类型：Boolean|Number|String|Buffer|Date
# $enums   {Array(*)}  枚举范围
# $min     {Number}    Number最小值|String最小长度|Buffer最小长度|Date最小时间戳
# $max     {Number}    Number最大值|String最大长度|Buffer最大长度|Date最大时间戳



DataChecker.check = (data={}, schema={}) ->
  for key, rule of schema
    value = _.get(data, key)
    @checkEach(key, value, rule)



DataChecker.checkEach = (key, value, rule) ->
  @checkRequire(key, value, rule)
  if value is null
    return
  @checkType(key, value, rule)
  @checkEnums(key, value, rule)
  @checkMin(key, value, rule)
  @checkMax(key, value, rule)



DataChecker.checkRequire = (key, value, rule) ->
  if rule.$require is true
    if value is null
      throw new Error.VALUE_CHECK_FAILED_REQUIRE({key})



DataChecker.checkType = (key, value, rule) ->
  switch rule.$type
    when Boolean
      if typeof(value) isnt 'boolean'
        throw new Error.VALUE_CHECK_FAILED_TYPE_BOOLEAN({key})
    when Number
      if typeof(value) isnt 'number'
        throw new Error.VALUE_CHECK_FAILED_TYPE_NUMBAR({key})
    when String
      if typeof(value) isnt 'string'
        throw new Error.VALUE_CHECK_FAILED_TYPE_STRING({key})
    when Buffer
      if !(value instanceof Buffer)
        throw new Error.VALUE_CHECK_FAILED_TYPE_BUFFER({key})
    when !(value instanceof Date)
      if typeof(value) isnt ''
        throw new Error.VALUE_CHECK_FAILED_TYPE_DATE({key})



DataChecker.checkEnums = (key, value, rule) ->
  enums = rule.$enums
  if enums
    if !enums.includes(value)
      throw new Error.VALUE_CHECK_FAILED_ENUMS({key, enums})



# @TODO DATE
DataChecker.checkMin = (key, value, rule) ->
  min = rule.$min ? -Infinity
  switch rule.$type
    when Number
      if value < min
        throw new Error.VALUE_CHECK_FAILED_MIN_NUMBAR({key, value, min})
    when String
      if value.length < min
        throw new Error.VALUE_CHECK_FAILED_MIN_STRING({key, value, min})
    when Buffer
      if value.length < min
        throw new Error.VALUE_CHECK_FAILED_MIN_BUFFER({key, value, min})



# @TODO DATE
DataChecker.checkMax = (key, value, rule) ->
  max = rule.$max ? Infinity
  switch rule.$type
    when Number
      if value > max
        throw new Error.VALUE_CHECK_FAILED_MIN_NUMBAR({key, value, max})
    when String
      if value.length > max
        throw new Error.VALUE_CHECK_FAILED_MIN_STRING({key, value, max})
    when Buffer
      if value.length > max
        throw new Error.VALUE_CHECK_FAILED_MIN_BUFFER({key, value, max})



module.exports = DataChecker