_ = require('lodash')


module.exports = (schema) ->

  schema = Object.assign({}, schema)

  schema.id = { type: Number }
  schema.createDate  = { type: Date }
  schema.updateDate  = { type: Date }
  schema.removeDate  = { type: Date }
  schema.restoreDate = { type: Date }

  return schema