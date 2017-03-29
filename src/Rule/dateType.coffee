_ = require('lodash')


module.exports = (value) ->

  if !_.isDate(value)
    throw "value should be a Date."