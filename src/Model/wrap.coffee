module.exports = ( model ) ->

  model.findOne = @findOne.bind(@, model)
  model.find = @find.bind(@, model)
  model.count = @count.bind(@, model)
  model.create = @create.bind(@, model)
  model.update = @update.bind(@, model)
  model.updateMany = @updateMany.bind(@, model)
  model.remove = @remove.bind(@, model)
  model.aggregate = @aggregate.bind(@, model)