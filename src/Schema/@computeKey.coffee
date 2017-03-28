_ = require('lodash')


module.exports = (schema) ->

  cursor = []

  forEach = (node) ->

    if [Boolean, Number, String, Buffer, Date].includes(node.type)
      node.keyAbs = cursor.join('.')
      node.key = cursor[cursor.length-1]
      return

    for key, child of node

      cursor.push(key)

      if _.isPlainObject(child)
        forEach(child)

      else if _.isArray(child)
        forEach(child[0])

      cursor.pop()

  forEach(schema)