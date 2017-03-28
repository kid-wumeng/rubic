_ = require('lodash')


module.exports = (opt, model) ->

  opt ?= {}

  if _.isString(opt)
    fields = opt
    opt = {fields}

  opt = Object.assign({}, opt)

  @formatQueryOptFields(opt, model)
  @formatQueryOptSkipAndLimit(opt)

  return opt