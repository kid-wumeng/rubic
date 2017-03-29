Schema = require('../Schema')


module.exports = ( model, query, opt ) ->

  {collection} = model

  query = @formatQuery(query)
  opt = @formatQueryOpt(opt, model)

  count = await @db
    .collection(collection)
    .count(query, opt)

  return count