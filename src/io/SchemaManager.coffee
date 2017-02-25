_ = require('lodash')
SchemaFormater = require('./SchemaFormater')
SchemaSplicer = require('./SchemaSplicer')



class SchemaManager



SchemaManager.dict = (schema) ->



SchemaManager.add = (schema) ->
  name = schema.$name
  # @TODO 检查是否重复
  @dict[name] = schema



SchemaManager.format = () ->
  for name, schema of @dict
    SchemaFormater.formatLogogram(schema)
  @dict = SchemaSplicer.spliceDict(@dict)
  for name, schema of @dict
    @dict[name] = SchemaFormater.formatLinear(schema)



module.exports = SchemaManager