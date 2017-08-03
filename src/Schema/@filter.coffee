_ = require('lodash')
Rule = require('../Rule')


module.exports = (node, data, opt) ->

  opt ?= {}

  # 过滤值（值的校验是可选的）
  if @isRuleNode(node)
    rule = node
    value = data

    value = Rule.parseValue(rule, value)


    # @REVIEW
    if opt.out
      if !value
        return undefined


    if opt.check
      Rule.checkValue(rule, value)

    return value


  dataFiltered = {}


  for key, childNode of node


    # Object节点，递归过滤
    if _.isPlainObject(childNode)

      childData = _.get(data, key)
      childData = @filter(childNode, childData, opt)

      if childData isnt undefined
        _.set(dataFiltered, key, childData)


    # Array节点，过滤其中每一个数据项
    else if _.isArray(childNode)

      childNode = childNode[0]
      childDataArray = _.get(data, key)

      if _.isArray(childDataArray)
        childDataArray = childDataArray.map (childData) =>
          return @filter(childNode, childData, opt)

        _.set(dataFiltered, key, childDataArray)



  if _.isEmpty(dataFiltered)
    return undefined
  else
    return dataFiltered