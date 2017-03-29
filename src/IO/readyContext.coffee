_ = require('lodash')
Model = require('../Model')
Redis = require('../Redis')


module.exports = (ctx) ->


  ctx.rubicIOCallChain = []


  ctx.io = {}

  for name, io of @dict
    io = io.bind(ctx)
    _.set(ctx.io, name, io)


  ctx.model = Model.dict


  ctx.redis = Redis.client


  ctx.signToken = @signToken.bind(ctx, @tokenDict)