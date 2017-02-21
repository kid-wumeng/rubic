co = require('co')
Store = require('./Store')
DB = require('./database/DB')
SchemaFactory = require('./schema/SchemaFactory')



class Runtime



Runtime.start = () ->
  Store.config =
    database:
      name: 'test'
  Store.database = yield DB.connect()
  



module.exports = Runtime