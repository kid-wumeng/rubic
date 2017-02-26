requireDir = require('require-dir')
SchemaManager = require('./io/SchemaManager')
IOManager = require('./io/IOManager')



class Core



Core.init = (config) ->
  dictSchema = requireDir(config.dir.schema)
  SchemaManager.save(dictSchema)
  SchemaManager.formatBaseSchemaDict()

  dictIODefine = requireDir(config.dir.io)
  IOManager.save(dictIODefine)
  IOManager.format()



Core.call = (name, data) ->
  ioDefine = IOManager.dictIODefine[name]
  if ioDefine and ioDefine.public
    io = IOManager.dictIO[name]
    return await io(data)
  else
    # @TODO Error
    throw '无此API'



# Core.table = (table, schema) ->
#   schema ?= table
#   schema = Store.schemaDict[schema]
#   # @TODO 存在性检查
#   return new Query({table, schema})



module.exports = Core