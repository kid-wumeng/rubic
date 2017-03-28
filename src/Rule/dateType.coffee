_ = require('lodash')


module.exports = (value) ->

  if !_.isDate(value)
    throw new Error()