module.exports = ( model ) ->

  model.findOne = @findOne.bind(@, model)
  model.find = @find.bind(@, model)
  model.count = @count.bind(@, model)
  model.createOne = @createOne.bind(@, model)
  model.updateOne = @updateOne.bind(@, model)
  model.updateMany = @updateMany.bind(@, model)
  model.removeOne = @removeOne.bind(@, model)
  model.aggregate = @aggregate.bind(@, model)