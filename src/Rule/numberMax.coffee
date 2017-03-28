_ = require('lodash')


module.exports = (rule, value) ->

  max = rule.max ? Infinity

  if value > max
    throw new Error()