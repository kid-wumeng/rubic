require('colors')
Schema = require('./Schema')
Model = require('./Model')
IO = require('./IO')
Redis = require('./Redis')
Network = require('./Network')


exports.init = (cfg) ->

  try

    Schema.init(cfg)
    await Model.init(cfg)
    IO.init(cfg)
    Redis.init(cfg)
    Network.init(cfg)

    console.log 'rubic start, good luck everybody ~'.green

  catch error
    if typeof(error) is 'string'
      console.log error.red
    else
      console.log error