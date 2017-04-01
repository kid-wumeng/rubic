module.exports =


  iSchema:
    'user':
      $ref: 'User'

  oSchema:
    'user': 'User'


  io: ({id}) ->

    user = await @model.User.findOne(id)

    return {user}