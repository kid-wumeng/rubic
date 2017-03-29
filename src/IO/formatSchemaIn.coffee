_ = require('lodash')


module.exports = (io) ->

  { iSchema } = io

  if _.isPlainObject(iSchema)
    iSchemaArray = [iSchema]

  else if _.isArray(iSchema)
    iSchemaArray = iSchema

  else
    throw "iSchema should be an object or array."

  io.iSchemaArray = iSchemaArray.map(@formatSchema)