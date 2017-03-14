_ = require('lodash')



class SchemaSplicer



###
@PUBLIC
用于接合IO模式
###
SchemaSplicer.splice = (node, schemaDict) ->
  if Array.isArray(node)
    node[0] = @splice(node[0], schemaDict)
    return node
  if !_.isPlainObject(node)
    return node
  # 接合本节点$ref，参考的模式可能也有$ref，所以进行继承式接合
  ref = node.$ref
  while ref
    # @REVIEW 区分模式名与属性名（似乎影响加载性能）
    index = ref.indexOf('.')
    if index is -1
      refSchema = schemaDict[ref]
    else
      schemaName = ref.slice(0, index)
      propName = ref.slice(index+1)
      refSchema = _.get(schemaDict[schemaName], propName)
    node = Object.assign({}, refSchema, node)
    ref = refSchema.$ref
  # @TODO 是否需要删除
  delete node.$ref
  # 接合全部子节点
  for name, child of node
    node[name] = @splice(child, schemaDict)
  return node



###
@PUBLIC
用于生成基本模式字典
###
SchemaSplicer.spliceDict = (dict) ->
  for name, schema of dict
    dict[name] = @splice(schema, dict)
  return dict



module.exports = SchemaSplicer