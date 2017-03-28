module.exports = (node) ->
  return [Boolean, Number, String, Buffer, Date].includes(node.type)