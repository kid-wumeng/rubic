_ = require('lodash')


module.exports = (rule, value) ->

  value ?= rule.default
  value ?= undefined

  return value