_ = require('lodash')


module.exports = (value) ->

  if !_.isFinite(value)
    throw "value should be a number."