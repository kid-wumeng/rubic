Schema = require('../Schema')


module.exports = (schema) ->

  schema = Schema.reference(schema)

  Schema.computeKey(schema)
  Schema.formatRule(schema)

  return schema