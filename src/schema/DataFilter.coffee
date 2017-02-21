_ = require('lodash')
Error = require('../Error')



class DataFilter
# @TODO String 计数算法
# @TODO Buffer mimes



# 规则集
# $default {Boolean}   默认值，设置为null或undefined是没意义的
# $require {Boolean}   必要性
# $type    {Object}    可选类型：Boolean|Number|String|Buffer|Date
# $enums   {Array(*)}  枚举范围
# $min     {Number}    Number最小值|String最小长度|Buffer最小长度|Date最小时间戳
# $max     {Number}    Number最大值|String最大长度|Buffer最大长度|Date最大时间戳



DataFilter.filter = (schema={}, data={}) ->
  dataFiltered = {}
  for key, rule of schema
    # 格式化且通过检查的值
    value = @filterEach(data, key, rule)
    # 加入过滤数据集
    _.set(dataFiltered, key, value)
    # 从原始数据集中删除
    data = _.omit(data, key)
  # 全部规则校验完毕后，若原始数据集中还剩有属性，则说明是多余属性
  if !_.isEmpty(data)
    throw new Error.NeedlessDataError({data})
  return dataFiltered



DataFilter.filterEach = (data, key, rule) ->
  # 若属性为空，则有默认值填默认值，无默认值填null
  value = @formatValue(data, key, rule)
  # 若属性为空，且不是必要的，则跳过后续检查
  @checkExist(key, value, rule)
  if value is null
    return
  # 后续检查
  @checkType(key, value, rule)
  @checkEnums(key, value, rule)
  @checkMin(key, value, rule)
  @checkMax(key, value, rule)
  return value




DataFilter.formatValue = (data, key, rule) ->
  value = _.get(data, key)
  value ?= rule.$default
  value ?= null
  return value



# 检查必要性
DataFilter.checkExist = (key, value, rule) ->
  if rule.$require is true
    if value is null
      throw new Error.ValueExistError({key})



# 检查类型
DataFilter.checkType = (key, value, rule) ->
  switch rule.$type
    when Boolean
      if typeof(value) isnt 'boolean'
        throw new Error.ValueTypeError({key, value, expectType: Boolean})
    when Number
      if typeof(value) isnt 'number'
        throw new Error.ValueTypeError({key, value, expectType: Number})
    when String
      if typeof(value) isnt 'string'
        throw new Error.ValueTypeError({key, value, expectType: String})
    when Buffer
      if !(value instanceof Buffer)
        throw new Error.ValueTypeError({key, value, expectType: Buffer})
    when !(value instanceof Date)
      if typeof(value) isnt ''
        throw new Error.ValueTypeError({key, value, expectType: Date})



# 检查枚举范围
DataFilter.checkEnums = (key, value, rule) ->
  enums = rule.$enums
  if enums
    if !enums.includes(value)
      throw new Error.ValueEnumsError({key, value, enums})



# 检查最小值
DataFilter.checkMin = (key, value, rule) ->
  min = rule.$min ? -Infinity
  switch rule.$type
    when Number
      if value < min
        throw new Error.ValueMinError({key, value, min})
    when String
      if value.length < min
        throw new Error.ValueMinError({key, value, min})
    when Buffer
      if value.length < min
        throw new Error.ValueMinError({key, value, min})
    when Date
      if value.getTime() < min
        throw new Error.ValueMinError({key, value, min})



# 检查最大值
DataFilter.checkMax = (key, value, rule) ->
  max = rule.$max ? Infinity
  switch rule.$type
    when Number
      if value > max
        throw new Error.ValueMaxError({key, value, max})
    when String
      if value.length > max
        throw new Error.ValueMaxError({key, value, max})
    when Buffer
      if value.length > max
        throw new Error.ValueMaxError({key, value, max})
    when Date
      if value.getTime() > max
        throw new Error.ValueMaxError({key, value, max})



module.exports = DataFilter