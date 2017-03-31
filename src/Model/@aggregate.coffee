Schema = require('../Schema')


module.exports = ( model, pipeline, opt ) ->

  {collection} = model

  result = await @db
    .collection(collection)
    .aggregate(pipeline, opt).toArray()

  return result