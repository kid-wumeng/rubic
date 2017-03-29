_ = require('lodash')


module.exports = (rule, value) ->

  min = rule.min ? -Infinity

  if value < min
    throw "value should be >= #{min}, current #{value}."