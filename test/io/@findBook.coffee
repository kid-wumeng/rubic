module.exports =

  inSchema:
    id: 'Book.id'

  io: ({id}) ->
    await new Promise (resolve) ->
      aaa = () ->
        resolve('say ' + id)
      setTimeout(aaa, 3000)