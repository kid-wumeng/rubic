require('colors')
Schema = require('./Schema')
Model = require('./Model')


exports.init = (cfg) ->
  try

    Schema.init(cfg)
    await Model.init(cfg)

    res = await Model.dict['User'].find()
    console.log res

    console.log 'rubic start, good luck everybody ~'.green

  catch error
    if typeof(error) is 'string'
      console.log error.red
    else
      console.log error



exports.handleError = (error) ->
  if typeof(error) is 'string'
    console.log error.red
  else
    console.log error