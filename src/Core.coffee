Query = require('./database/Query')



class Core



Core.table = (table, schema) ->
  schema ?= table
  return new Query({table, schema})



module.exports = Core