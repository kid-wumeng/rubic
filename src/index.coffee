require('colors')
Schema = require('./Schema')
Model = require('./Model')


exports.init = (cfg) ->
  try

    Schema.init(cfg)
    await Model.init(cfg)

    console.log Model.dict['User'].findOne({}, {fields: '-createDate -updateDate -removeDate -restoreDate'})

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