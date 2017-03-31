module.exports =

  iSchema:
    'uid':
      $ref: 'User.id'
      must: true
    'sid':
      $ref: 'Subject.id'
      must: true

  oSchema:
    'user':
      $ref: 'User'

  io: ({uid, sid}) ->
    user = await @model.User.findOne(uid)
    subject = await @io.shop.findSubject({id: sid})
    return {user, subject, publishDate: new Date()}