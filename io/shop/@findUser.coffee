module.exports =

  token:
    user: true

  iSchema: [{
    $ref: 'User.id'
    must: true
  },{
    $ref: 'Subject.id'
    must: true
  }]

  oSchema:
    'user':
      $ref: 'User'

  io: (uid, sid) ->
    user = await @model.User.findOne(uid)
    subject = await @io.shop.findSubject({id: sid})
    return {user, subject}