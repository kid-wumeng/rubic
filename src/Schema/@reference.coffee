_ = require('lodash')
defaultsDeep = require('defaults-deep-preserve-arrays')



module.exports = (schema) ->

  execute = (node) =>

    if node.$ref
      refa = _.get(@dict, node.$ref)

      if !refa
        throw "$ref '#{node.$ref}' not found"

      # @TODO 数组规则的递归继承
      if _.isArray(refa)
        return refa
      else
        node = defaultsDeep(node, refa)

      if refa.$ref
        node.$ref = refa.$ref
      else
        delete node.$ref

      return execute(node)

    node = _.mapValues node, (value, key, parent) =>

      if _.isPlainObject(value)
        obj = value
        return execute(obj)

      if _.isArray(value)

        # 处理诸如enum之类的规则
        if @isRuleNode(parent)
          return value
        else
          obj = value[0]
          a = execute(obj)
          return [a]

      return value

    return node

  return execute(schema)