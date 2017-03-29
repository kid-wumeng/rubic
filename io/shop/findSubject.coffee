module.exports =

  iSchema:
    'id':
      $ref: 'Subject.id'
      must: true

  oSchema:
    'subject':
      $ref: 'Subject'

  io: ({id}) ->
    @signToken('user', {id: 3})
    return await @model.Subject.findOne(id)