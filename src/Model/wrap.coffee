module.exports = ( model ) ->

  model.findOne = (query, opt) =>
    @findOne(model, query, opt)