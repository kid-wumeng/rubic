Query = require('./Query')
Executor = require('./Executor')
Error = require('../../Error')



class Table
  constructor: ({@db, @tableName}) ->



Table.db = null
Table.tableName = null



Table.prototype.find = (args...) ->
  query = new Query({db: @db, tableName: @tableName})
  if args.length
    query.where(args...)
  return query



Table.prototype.findAll = (args...) ->
  query = new Query({db: @db, tableName: @tableName, all: true})
  if args.length
    query.where(args...)
  return query



Table.prototype.create = (data) ->
  executor = new Executor({db: @db, tableName: @tableName})
  return executor.create(data)



module.exports = Table