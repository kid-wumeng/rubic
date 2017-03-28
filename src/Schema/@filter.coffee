_ = require('lodash')
Rule = require('../Rule')


module.exports = (node, data) ->


  # 过滤值（值的校验是可选的）
  if @isRuleNode(node)
    rule = node
    value = data
    return Rule.parseValue(rule, value)


  dataFiltered = {}


  for key, childNode of node


    # Object节点，递归过滤
    if _.isPlainObject(childNode)

      childData = _.get(data, key)
      childData = @filter(childNode, childData)

      if childData
        _.set(dataFiltered, key, childData)


    # Array节点，过滤其中每一个数据项
    else if _.isArray(childNode)

      childNode = childNode[0]
      childDataArray = _.get(data, key)

      if childDataArray
        childDataArray = childDataArray.map (childData) => @filter(childNode, childData)

        _.set(dataFiltered, key, childDataArray)



  if _.isEmpty(dataFiltered)
    return undefined
  else
    return dataFiltered