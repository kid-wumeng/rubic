Schema = require('../Schema')


module.exports = ( model, pipeline, opt ) ->

  {collection} = model

  results = await @db
    .collection(collection)
    .aggregate(pipeline, opt).toArray()

  return results