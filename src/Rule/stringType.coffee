_ = require('lodash')


module.exports = (value) ->

  if !_.isString(value)
    throw new Error()