_ = require('lodash')


module.exports = (rule, value) ->

  max = rule.max ? Infinity

  if value > max
    throw "value should be <= #{max}, current #{value}."