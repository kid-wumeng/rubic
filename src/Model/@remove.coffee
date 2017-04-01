module.exports = (model, query) ->

  {collection} = model

  query = @formatQuery(query)

  modifier =
    $set: {'removeDate': new Date()}

  await @db
    .collection(collection)
    .updateOne(query, modifier)

  return undefined