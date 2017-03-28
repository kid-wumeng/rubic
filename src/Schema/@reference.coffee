_ = require('lodash')


module.exports = (schema) ->

  execute = (node) =>
    if node.$ref
      refa = _.get(@dict, node.$ref)
      if !refa
        throw "$ref '#{node.$ref}' not found"
      node = _.defaultsDeep(node, refa)

      if refa.$ref
        node.$ref = refa.$ref
      else
        delete node.$ref

      return execute(node)

    node = _.mapValues node, (value, key) =>

      if _.isPlainObject(value)
        obj = value
        return execute(obj)

      if _.isArray(value)
        obj = value[0]
        a = execute(obj)
        return [a]


      return value

    return node

  return execute(schema)