_ = require('lodash')
deepKeys = require('deep-keys')



class SchemaFactory



SchemaFactory.createLinearSchemaDict = (completeSchemaDict) ->
  linearSchemaDict = {}
  for name, completeSchema of completeSchemaDict
    linearSchemaDict[name] = @createLinearSchema(completeSchema)
  return linearSchemaDict



SchemaFactory.createLinearSchema = (completeSchema) ->
  # 获取键名集合，剪叶（叶子节点都是规则的细节）
  keys = @trimLeaf(completeSchema)
  # 获取线性模式，剪枝（枝节点都是过路的，没有规则）
  linearSchema = @trimBranch(completeSchema, keys)
  # 挂载完整模式
  Object.defineProperty(linearSchema, 'completeSchema', {
    value: completeSchema
    enumerable: false
  })
  return linearSchema



SchemaFactory.trimLeaf = (schema) ->
  allKeys = deepKeys(schema, true)
  endKeys = deepKeys(schema)
  return _.difference(allKeys, endKeys)



SchemaFactory.trimBranch = (schema, keys) ->
  rule = {}
  for key in keys
    node = _.get(schema, key)
    if node.$type
      rule[key] = node
  return rule



SchemaFactory.createCompleteSchemaDict = (schemas) ->
  dict = @createSchemaDict(schemas)
  for name, schema of dict
    schema = @formatSimpleRule(schema)
    dict[name] = @parseCompleteNode(schema, dict)
  return dict



SchemaFactory.parseCompleteNode = (node, dict) ->
  if not @isPlainNode(node)
    return node
  node = @inherit(node, dict)
  for name, child of node
    node[name] = @parseCompleteNode(child, dict)
  return node



# 朴素节点必须是朴素对象，且不包含规则
SchemaFactory.isPlainNode = (node) ->
  return _.isPlainObject(node) and !node.$type



SchemaFactory.createSchemaDict = (schemas) ->
  dict = {}
  for schema in schemas
    dict[schema.$name] = schema
  return dict



# 将简写规则变为常规格式
# 例1. {name: String} -> {name: {$type: String}}
# 例2. {book: 'Book'} -> {book: {$from: 'Book'}}
SchemaFactory.formatSimpleRule = (schema) ->
  queue = [schema]
  while queue.length
    node = queue.shift()
    for name, value of node
      if name[0] isnt '$'
        node[name] = @formatSimpleRuleEach(value)
        queue.push(value)
  return schema



SchemaFactory.formatSimpleRuleEach = (value) ->
  if [Boolean, Number, String, Date, Buffer].includes(value)
    return {$type: value}
  if typeof(value) is 'string'
    return {$from: value}
  return value



SchemaFactory.inherit = (node, dict) ->
  from = node.$from
  while from
    parent = _.get(dict, from)
    node = Object.assign({}, parent, node)
    from = parent.$from
  return node



module.exports = SchemaFactory