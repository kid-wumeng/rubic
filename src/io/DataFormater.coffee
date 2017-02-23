_ = require('lodash')



class DataFormater



DataFormater.format = (data, schema) ->
  @formatObject(data, schema)



DataFormater.formatObject = (data, schema) ->
  # 只处理朴素对象
  if !_.isPlainObject(data)
    return null
  # 不能直接修改源数据的理由：
  # 1. 过滤多余数据
  # 2. 源数据可能被多个IO使用，即可能被多个Schema格式化
  dataFormatted = {}
  # 遍历模式规则，逐条比对
  for key, rule of schema
    value = _.get(data, key)
    # 处理数组
    if rule.$type is Array
      value = @formatArray(value, rule.$schema)
    # 处理值
    else
      value = @formatValue(value, rule)
    # 处理完毕，添加
    # 因为是线性化模式，所以无需处理嵌套的对象
    _.set(dataFormatted, key, value)
  return dataFormatted



DataFormater.formatArray = (array, schema) ->
  # 只处理数组
  if not Array.isArray(array)
    return []
  # 遍历并格式化节点
  array = array.map (node) =>
    # 如果模式有$type属性，表示数组中应该是值节点，比如[1, 2, 3]
    if schema.$type
      return @formatValue(node, schema)
    # 否则表示数组中应该是对象，比如[{name: 'kid'}, {name: 'wumeng'}]
    else
      return @formatObject(node, schema)
    # @REVIEW 暂时不支持数组中直接嵌套数组，比如[[1, 2, 3], [1, 2, 3]]
  # 删除空节点
  array = array.filter (node) -> node isnt null
  return array



DataFormater.formatValue = (value, rule) ->
  switch rule.$type
    when Boolean
      value = null if !_.isBoolean(value)
    when Number
      value = null if !_.isNumber(value)
    when String
      value = null if !_.isString(value)
    when Buffer
      value = null if not (value instanceof Buffer)
    when Date
      value = null if not (value instanceof Date)
  # 如果值为空，则设为默认值；如果连默认值也没有，则设为null
  value ?= rule.$default ? null
  return value



module.exports = DataFormater