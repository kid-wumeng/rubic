_ = require('lodash')


module.exports = (schema, callback) ->

  forEach = (node) =>

    if @isRuleNode(node)
      callback(node)
      return

    for key, child of node

      if _.isPlainObject(child)
        forEach(child)

      else if _.isArray(child)
        forEach(child[0])

  forEach(schema)