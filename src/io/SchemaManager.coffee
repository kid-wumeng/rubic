_ = require('lodash')



class SchemaManager



SchemaManager.dict = (schema) ->



SchemaManager.add = (schema) ->
  name = schema.$name
  # @TODO 检查是否重复
  @dict[name] = schema



module.exports = SchemaManager