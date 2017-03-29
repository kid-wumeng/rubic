module.exports = (model) ->

  {collection} = model

  query    = {collection}
  modifier = {$inc: {'id': 1}}
  opt      = {upsert: true, returnOriginal: false}

  result = await @db
    .collection('IDStore')
    .findOneAndUpdate(query, modifier, opt)

  return result.value.id