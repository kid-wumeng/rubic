_ = require('lodash')


module.exports = (rule, value) ->

  max = rule.max ? Infinity

  if value.length > max
    throw "value should be <= #{max} bytes, current #{value.length}."