_ = require('lodash')
Helper = require('../Helper')


module.exports = (ctx) ->

  {data} = ctx.response

  if data
    if !_.isPlainObject(data)
      throw "response-data should be a plain-object."
  else
    return

  Helper.traverseLeaf data, (value, key, parent) ->

    if _.isDate(value)
      date = value
      timeStamp = date.getTime()
      parent[key] = "\/Date\(#{timeStamp}\)\/"

  ctx.response.body = ctx.response.data