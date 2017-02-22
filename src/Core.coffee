Store = require('./Store')
Query = require('./database/Query')



class Core



Core.table = (table, schema) ->
  schema ?= table
  schema = Store.schemaDict[schema]
  # @TODO 存在性检查
  return new Query({table, schema})



module.exports = Core