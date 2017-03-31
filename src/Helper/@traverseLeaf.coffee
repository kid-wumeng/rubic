_ = require('lodash')


module.exports = (tree, callback) ->


  cursor = []


  forEach = (node) =>

    if _.isPlainObject(node)
      for name, child of node
        cursor.push(name)
        forEach(child)
        cursor.pop()

    else if _.isArray(node)
      for child, i in node
        cursor.push(i)
        forEach(child)
        cursor.pop()

    else
      key = cursor.join('.')
      value = node
      callback(key, value)


  forEach(tree)