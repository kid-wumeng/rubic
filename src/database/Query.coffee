_ = require('lodash')
DB = require('./DB')
Error = require('../Error')



class Query
  constructor: ({@table, @schema}) ->



Query.prototype.find = () ->
  return DB.find(@)



module.exports = Query