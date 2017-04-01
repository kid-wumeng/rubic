module.exports = (model, query, modifier) ->

  {collection, schema} = model

  query = @formatQuery(query)
  modifier = @formatModifier(modifier)

  await @db
    .collection(collection)
    .updateOne(query, modifier)

  return undefined