Query = require('./Query')
Executor = require('./Executor')
Error = require('../../Error')



class Table
  constructor: ({@db, @tableName}) ->



Table.prototype.find = (args...) ->
  query = new Query({db: @db, tableName: @tableName})
  if args.length
    # @REVIEW 放在这是否合适？
    if args.length is 1 and typeof(args[0]) is 'number'
      query.where('id', args[0])
      return query.fetch()
    else
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