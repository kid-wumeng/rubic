Schema = require('../Schema')


module.exports = (model, query, modifier) ->

  {collection, schema} = model

  query    = @formatQuery(query)
  modifier = @formatModifier(modifier)
  opt      = {returnOriginal: false}

  modifier.$set = Schema.filter(schema, modifier.$set)

  result = await @db
    .collection(collection)
    .findOneAndUpdate(query, modifier, opt)

  # @TODO 安全检查
  doc = result.value
  return doc