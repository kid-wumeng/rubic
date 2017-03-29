module.exports = (schema) ->

  schema.id = { type: Number }
  schema.createDate  = { type: Date }
  schema.updateDate  = { type: Date }
  schema.removeDate  = { type: Date }
  schema.restoreDate = { type: Date }