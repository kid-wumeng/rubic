require('colors')
Schema = require('./Schema')


schemaDict = null


exports.init = (cfg) ->
  try

    {schemaDict} = Schema.init(cfg)

    console.log 'rubic start, good luck everybody ~'.green

  catch error
    @handleError(error)



exports.handleError = (error) ->
  if typeof(error) is 'string'
    console.log error.red
  else
    console.log error