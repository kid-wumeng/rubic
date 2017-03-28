Schema = require('../Schema')


module.exports = ( model, query, opt ) ->

  {collection, schema} = model

  query = @formatQuery(query)
  opt = @formatQueryOpt(model, opt)

  data = await @db.collection(collection)
    .findOne(query, opt)

  if data
    data = Schema.filter(schema, data)


  return data
  # if data
  #   data = Schema.filter(schema, data)
  #   if opt.join
  #     await @findOneJoin({model, data, opt})

  # return data