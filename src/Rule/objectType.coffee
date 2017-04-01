_ = require('lodash')


module.exports = (value) ->

  if !_.isPlainObject(value)
    throw "value should be a plain-object."