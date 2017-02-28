module.exports =

  iSchema:
    id:
      $ref: 'Book.id'
      $check: (id) ->
        return id > 6
    name:
      $type: String
      $format: 'email'
    faces: [{
      $type: Buffer
      $mimes: ['image/jpeg']
    }]



  oSchema:
    talk: String


  io: (data) ->
    @signToken('user', {
      user: {id: 1}
    })
    return {talk: 'say ' + data.id}
