module.exports =


  iSchema:
    type: String
    must: true


  oSchema:
    type: String
    must: true


  io: (text) ->

    return 'hello ' + text