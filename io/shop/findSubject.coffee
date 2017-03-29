module.exports =

  iSchema:
    'id':
      $ref: 'Subject.id'
      must: true

  oSchema:
    'subject':
      $ref: 'Subject'

  io: ({id}) ->
    return await @model.Subject.findOne(id)