colors = require('colors')
requireDir = require('require-dir')
SchemaManager = require('./io/SchemaManager')
IOManager = require('./io/IOManager')
TokenManager = require('./io/TokenManager')
HTTPServer = require('./net/HTTPServer')
DB = require('./database/MongoDB/DB')



class Core



Core.init = (config) ->
  try

    dictSchema = requireDir(config.dir.schema)
    SchemaManager.save(dictSchema)
    SchemaManager.formatBaseSchemaDict()

    dictIODefine = requireDir(config.dir.io)
    IOManager.save(dictIODefine)
    IOManager.format()

    TokenManager.saveDict(config.token)
    TokenManager.saveSecret(config.tokenSecret)

    await DB.connect(config.database)

    HTTPServer.listen(3000)
    console.log 'rubic start, good luck ~'.green

  catch error
    console.log error



module.exports = Core