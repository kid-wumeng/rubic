require('colors')
Schema = require('./Schema')
Model = require('./Model')
IO = require('./IO')


exports.init = (cfg) ->
  try

    Schema.init(cfg)
    await Model.init(cfg)
    IO.init(cfg)

    ctx =
      iDataArray: [4, 6]
      iToken:
        $type: 'user'
        $expires: Date.now() + 10000000
    await IO.callByRequest('shop.findUser', ctx)


    console.log 'rubic start, good luck everybody ~'.green

  catch error
    if typeof(error) is 'string'
      console.log error.red
    else
      console.log error