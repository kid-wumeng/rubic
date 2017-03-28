_ = require('lodash')


module.exports = (rule, value) ->

  if rule.must
    if _.isNil(value)
      throw new Error()