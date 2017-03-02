Error = require('../../Error')



class Executor
  constructor: ({@db, @tableName}) ->



Executor.prototype.makeID = () ->
  result = await @db.collection('IDStore').findOneAndUpdate({
    table: @tableName
  },{
    $inc:{id: 1}
  },{
    upsert: true
    returnOriginal: false
  })
  return result.value.id



Executor.prototype.find = (query, option) ->
  query.removeDate = {$exists: false}
  return await @db
    .collection(@tableName)
    .findOne(query, option)



Executor.prototype.findAll = (query, option) ->
  query.removeDate = {$exists: false}
  return await @db
    .collection(@tableName)
    .find(query, option)
    .toArray()



Executor.prototype.create = (data={}) ->
  data.id = await @makeID(@tableName)
  data.createDate = new Date()
  result = await @db
    .collection(@tableName)
    .insertOne(data)
  return result.ops[0]



Executor.prototype.update = (query, modifier) ->
  modifier.$set.updateDate = new Date()
  delete modifier.$set.id
  option = {returnOriginal: false}
  result = await @db
    .collection(@tableName)
    .findOneAndUpdate(query, modifier, option)
  return result.value



Executor.prototype.remove = (query) ->
  modifier =
    $set:
      removeDate: new Date()
  await @db
    .collection(@tableName)
    .updateOne(query, modifier)
  return null



Executor.prototype.restore = (query) ->
  modifier =
    $unset:
      removeDate: ''
    $set:
      restoreDate: new Date()
  option =
    returnOriginal: false
  result = await @db
    .collection(@tableName)
    .findOneAndUpdate(query, modifier, option)
  return result.value



Executor.prototype.delete = (query) ->
  await @db
    .collection(@tableName)
    .deleteOne(query)
  return null



module.exports = Executor