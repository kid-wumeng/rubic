_ = require('lodash')


module.exports = (node) ->

  if _.isPlainObject(node)
    if [Boolean, Number, String, Buffer, Date, Object].includes(node.type)
      return true

  return false