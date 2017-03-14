_ = require('lodash')
fileType = require 'file-type'
Error = require('../Error')



class DataChecker
# @TODO String 计数算法
# @TODO Buffer mimes



# 规则集
# $default  {Boolean}         默认值，设置为null或undefined是没意义的
# $require  {Boolean}         必要性
# $type     {Object}          可选类型：Boolean|Number|String|Buffer|Date
# $enums    {Array(*)}        枚举范围
# $min      {Number}          Number最小值|String最小长度|Buffer最小长度|Date最小时间戳
# $max      {Number}          Number最大值|String最大长度|Buffer最大长度|Date最大时间戳
# $format   {String}          字符串格式，暂时只支持'email'
# $mimes    {Array[String]}   允许的文件MIME类型，Buffer专用规则
# $check    {Function}        开发者自己定义的规则，属性值作为参数传入，返回true/false代表是否通过



DataChecker.check = (data={}, schema) ->
  @checkObject('', data, schema)



DataChecker.checkObject = (baseKey, data, schema) ->
  # 只处理朴素对象
  if !_.isPlainObject(data)
    return
  # 遍历模式规则，逐条比对
  for key, rule of schema
    key = if baseKey then "#{baseKey}.#{key}" else key
    value = _.get(data, key)
    # 处理数组
    if rule.$type is Array
      @checkArray(key, value, rule.$schema)
    # 处理值
    else
      @checkValue(key, value, rule)



DataChecker.checkArray = (key, array, schema) ->
  # 只处理数组
  if not Array.isArray(array)
    return
  # 遍历并格式化节点
  for node in array
    # 如果模式有$type属性，表示数组中应该是值节点，比如[1, 2, 3]
    if schema.$type
      @checkValue(key, node, schema)
    # 否则表示数组中应该是对象，比如[{name: 'kid'}, {name: 'wumeng'}]
    else
      @checkObject(key, node, schema)
    # @REVIEW 暂时不支持数组中直接嵌套数组，比如[[1, 2, 3], [1, 2, 3]]



DataChecker.checkValue = (key, value, rule) ->
  @checkRequire(key, value, rule)
  if value is undefined
    return
  @checkType(key, value, rule)
  @checkEnums(key, value, rule)
  @checkMin(key, value, rule)
  @checkMax(key, value, rule)
  @checkMimes(key, value, rule)
  @checkFormat(key, value, rule)
  @checkCustom(key, value, rule)



DataChecker.checkRequire = (key, value, rule) ->
  if rule.$require is true
    if value is undefined
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
      if @countChar(value) < min
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
        throw new Error.VALUE_CHECK_FAILED_MAX_NUMBAR({key, value, max})
    when String
      if @countChar(value) > max
        throw new Error.VALUE_CHECK_FAILED_MAX_STRING({key, value, max})
    when Buffer
      if value.length > max
        throw new Error.VALUE_CHECK_FAILED_MAX_BUFFER({key, value, max})



DataChecker.checkFormat = (key, value, rule) ->
  if rule.$type is String and rule.$format
    switch rule.$format
      when 'email'
        if not /^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$/.test(value)
          throw "#{key}不是符合格式的email地址"



DataChecker.checkMimes = (key, value, rule) ->
  if rule.$type is Buffer
    mimes = rule.$mimes
    mime = fileType(value).mime
    if mimes and !mimes.includes(mime)
      throw new Error.VALUE_CHECK_FAILED_MIMES({key, value, mimes})



DataChecker.checkCustom = (key, value, rule) ->
  check = rule.$check
  if check
    if check(value) isnt true
      throw new Error.VALUE_CHECK_FAILED_CUSTOM({key, value})



# @TODO 暂时全使用width模式
DataChecker.countChar = (string) ->
  count = 0
  for char, i in string
    code = string.charCodeAt(i)
    count += if code <= 255 then 1 else 2
  return count



module.exports = DataChecker