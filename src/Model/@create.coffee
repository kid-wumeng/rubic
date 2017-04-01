_ = require('lodash')
Schema = require('../Schema')


module.exports = (model, data) ->

  {collection, schema} = model

  if !_.isPlainObject(data)
    throw "@model('#{collection}').create(data),
           data should be a plain-object."

  data = Schema.filter(schema, data, {
    check: true
  })

  data.id = await @makeID(model)
  data.createDate = new Date()

  result = await @db
    .collection(collection)
    .insertOne(data)

  # @TODO 安全检查
  doc = result.ops[0]
  return doc