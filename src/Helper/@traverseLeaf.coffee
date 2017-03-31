_ = require('lodash')


module.exports = (tree, callback) ->

  forEach = (node, key, parent) =>

    if _.isPlainObject(node)
      for childKey, child of node
        forEach(child, childKey, node)

    else if _.isArray(node)
      for child, i in node
        forEach(child, i, node)

    else
      callback(node, key, parent)


  forEach(tree, null, null)