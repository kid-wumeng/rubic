requireDir = require('require-dir')
SchemaManager = require('./io/SchemaManager')
IOManager = require('./io/IOManager')
TokenManager = require('./io/TokenManager')
HTTPServer = require('./net/HTTPServer')



class Core



Core.init = (config) ->
  dictSchema = requireDir(config.dir.schema)
  SchemaManager.save(dictSchema)
  SchemaManager.formatBaseSchemaDict()

  dictIODefine = requireDir(config.dir.io)
  IOManager.save(dictIODefine)
  IOManager.format()

  TokenManager.saveDict(config.token)
  TokenManager.saveSecret(config.tokenSecret)

  HTTPServer.listen(3000)



# Core.table = (table, schema) ->
#   schema ?= table
#   schema = Store.schemaDict[schema]
#   # @TODO 存在性检查
#   return new Query({table, schema})



module.exports = Core