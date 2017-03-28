module.exports = ( model ) ->

  model.findOne = (query, opt) =>
    @findOne(model, query, opt)

  model.find = (query, opt) =>
    @find(model, query, opt)