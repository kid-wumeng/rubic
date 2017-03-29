_ = require('lodash')


module.exports = (value) ->

  if !_.isBoolean(value)
    throw "value should be a boolean."