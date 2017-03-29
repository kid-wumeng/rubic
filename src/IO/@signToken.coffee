_ = require('lodash')


module.exports = (tokenDict, type, payload) ->


  if !tokenDict[type]
    throw "token-type '#{type}' is not configured."


  payload ?= {}


  if !_.isPlainObject(payload)
    throw "token-payload should be a plain-object."


  days = tokenDict[type]
  milliSeconds = parseInt(days * 24 * 60 * 60 * 1000)
  expires = Date.now() + milliSeconds


  @oToken = Object.assign({}, payload)
  @oToken.$type = type
  @oToken.$expires = expires