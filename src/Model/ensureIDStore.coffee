module.exports = (model) ->

  {collection} = model

  idStore = await @db
    .collection('IDStore')
    .findOne({collection})

  sort = id: -1
  fields = id: 1

  last = await @db
    .collection(collection).findOne({}, {sort, fields})

  if !idStore and !last
    return

  if idStore and !last
    throw "collection <#{collection}>:
           not found collection but idStore is existed."

  if last and !idStore
    throw "collection <#{collection}>:
           not found idStore."

  # @TODO 硬删除时？
  if idStore.id isnt last.id
    throw "collection <#{collection}>:
           the 'id' of last document is not match to idStore."