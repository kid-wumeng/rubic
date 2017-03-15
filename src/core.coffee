require('colors')
model = require('./model')
schema = require('./schema')
io = require('./io')
net = require('./net')



exports.init = (cfg) ->
  try

    await model.init(cfg)
    schema.init(cfg)
    io.init(cfg)
    net.init(cfg)

    console.log 'rubic start, good luck everybody ~'.green

  catch error
    @handleError(error)



exports.handleError = (error) ->
  if typeof(error) is 'string'
    console.log error.red
  else
    console.log error