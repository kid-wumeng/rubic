_ = require('lodash')


module.exports = (define) ->

  { iSchema } = define

  if _.isPlainObject(iSchema)
    iSchemaArray = [iSchema]

  else if _.isArray(iSchema)
    iSchemaArray = iSchema

  else
    throw "iSchema should be an object or array."

  define.iSchemaArray = iSchemaArray.map(@formatSchema)