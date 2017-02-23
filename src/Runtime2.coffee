co = require('co')
Store = require('./Store')
DB = require('./database/DB')
SchemaFactory = require('./schema/SchemaFactory')



class Runtime



Runtime.start = () ->
  yield DB.connect({name: 'test'})

  People =
    $name: 'People'

  schemas = [People]

  Store.schemaDict = SchemaFactory.createLinearSchemaDict(schemas)




module.exports = Runtime