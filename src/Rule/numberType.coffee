_ = require('lodash')


module.exports = (value) ->

  if !_.isFinite(value)
    throw new Error()