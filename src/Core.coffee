require('colors')
model = require('./model')
schema = require('./schema')
io = require('./io')



exports.init = (cfg) ->
  try

    await model.init(cfg)
    schema.init(cfg)
    io.init(cfg)

    ctx =
      data: [77, 99]
      token: 'kid-token'
    await io.call('add', ctx)
    console.log ctx.body

  catch error
    if typeof(error) is 'string'
      console.log error.red
    else
      console.log error