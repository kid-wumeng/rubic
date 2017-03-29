_ = require('lodash')


module.exports = (value) ->

  if !_.isString(value)
    throw "value should be a string."