require('colors')
redis = require('./redis')
schema = require('./schema')
io = require('./io')
model = require('./model')
net = require('./net')



exports.init = (cfg) ->
  try

    await redis.init(cfg)
    schema.init(cfg)
    io.init(cfg)
    await model.init(cfg)
    net.init(cfg)

    console.log 'rubic start, good luck everybody ~'.green

  catch error
    @handleError(error)



exports.handleError = (error) ->
  if typeof(error) is 'string'
    console.log error.red
  else
    console.log error