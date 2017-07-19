Schema = require('../Schema')


module.exports = ( model, query, opt ) ->

  {collection, schema} = model

  query = @formatQuery(query)
  opt = @formatQueryOpt(opt, model)

  data = await @db
    .collection(collection)
    .findOne(query, opt)

  # if data
  #   data = Schema.filter(schema, data)

  if opt.join
    await @findOneJoin(schema, data, opt.join)

  return data