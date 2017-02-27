module.exports =

  iSchema:
    id: 'Book.id'
    face: Buffer

  oSchema:
    talk: String


  io: ({id}) ->
    @signToken('user', {
      user: {id: 1}
    })
    return {talk: 'say ' + id}
