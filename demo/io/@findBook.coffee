module.exports =

  iSchema:
    id: 'Book.id'
    face: Buffer

  oSchema:
    talk: String

  io: ({id}) ->
    return {talk: 'say ' + id}