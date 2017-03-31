_ = require('lodash')


module.exports = (rule, value) ->

  min = rule.min ? -Infinity

  if value.length < min
    throw "value should be >= #{min} bytes, current #{value.length}."