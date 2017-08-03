Schema = require('../Schema')


module.exports = ( model, query, opt ) ->

  {collection, schema} = model

  query = @formatQuery(query)
  opt = @formatQueryOpt(opt, model)

  datas = await @db
    .collection(collection)
    .find(query, opt)
    .toArray()

  if datas.length
    datas = datas.map (data) ->
      return Schema.filter(schema, data, {out: true})

  if opt.join
    await @findJoin(schema, datas, opt.join)

  return datas