_ = require('lodash')
Model = require('../Model')


module.exports = (ctx) ->

  ctx.io = {}

  for name, io of @dict
    io = io.bind(ctx)
    _.set(ctx.io, name, io)

  ctx.model = Model.dict