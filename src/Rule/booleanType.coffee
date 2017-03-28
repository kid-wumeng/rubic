_ = require('lodash')


module.exports = (value) ->

  if !_.isBoolean(value)
    throw new Error()