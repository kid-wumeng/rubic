module.exports = (model) ->

  {collection} = model

  await @db.collection(collection)
    .createIndex({
      id: 1
    },{
      unique: true
    })