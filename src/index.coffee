require('colors')
Schema = require('./Schema')
Model = require('./Model')


exports.init = (cfg) ->
  try

    Schema.init(cfg)
    await Model.init(cfg)

    # res = await Model.dict['Collection'].find({id: 1}, {
    #   join:
    #     'user': 'email'
    #     'fans': '-name'
    # })

    res = await Model.dict['User'].findOne({}, '-comment')

    console.log require('util').inspect(res, {depth: 10})

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