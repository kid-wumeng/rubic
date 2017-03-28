_ = require('lodash')
Rule = require('../Rule')


module.exports = (node, data) ->

  if [Boolean, Number, String, Buffer, Date].includes(node.type)
    rule = node
    value = data
    return Rule.parseValue(rule, value)


  dataFiltered = {}

  for key, childNode of node

    if _.isPlainObject(childNode)

      childData = _.get(data, key)
      childData = @filter(childNode, childData)
      if childData
        _.set(dataFiltered, key, childData)

    else if _.isArray(childNode)
      childNode = childNode[0]

      childDataArray = _.get(data, key)

      if childDataArray

        childDataArray = childDataArray.map (childData) =>
          return @filter(childNode, childData)

        _.set(dataFiltered, key, childDataArray)

  if _.isEmpty(dataFiltered)
    return undefined
  else
    return dataFiltered