_ = require('lodash')


module.exports = (model, opt) ->
  
  opt ?= {}
  opt = Object.assign({}, opt)

  @formatQueryOptFields(model, opt)
  @formatQueryOptSkipAndLimit(model, opt)

  return opt