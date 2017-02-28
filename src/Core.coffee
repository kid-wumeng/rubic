colors = require('colors')
requireDir = require('require-dir')
SchemaManager = require('./io/SchemaManager')
IOManager = require('./io/IOManager')
TokenManager = require('./io/TokenManager')
HTTPServer = require('./net/HTTPServer')



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

    # @TEMP
    DB = require('./database/MongoDB/DB')
    await DB.connect(config.database)
    book = await DB.table('Book').create({name: '三国志'})
    console.log book



    # HTTPServer.listen(3000)
    # console.log 'rubik start, good luck ~'.green
  catch error
    console.log error.message.red



module.exports = Core