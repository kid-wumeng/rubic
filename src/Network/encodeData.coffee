_ = require('lodash')
Helper = require('../Helper')


module.exports = (ctx) ->


  {oData} = ctx


  if oData is undefined
    return


  else if _.isBoolean(oData)
    ctx.set('Rubic-O-Data-Type', 'boolean')
    ctx.body = oData


  else if _.isFinite(oData)
    ctx.set('Rubic-O-Data-Type', 'number')
    ctx.body = oData


  else if _.isString(oData)
    ctx.set('Rubic-O-Data-Type', 'string')
    ctx.body = oData


  else if _.isDate(oData)
    ctx.set('Rubic-O-Data-Type', 'date')
    ctx.body = oData.getTime()


  else

    if _.isPlainObject(oData)
      ctx.set('Rubic-O-Data-Type', 'plain-object')

    else if _.isArray(oData)
      ctx.set('Rubic-O-Data-Type', 'array')

    $json = {}
    $date = {}

    Helper.traverseLeaf oData, (key, value) ->
      switch
        when _.isBoolean(value), _.isFinite(value), _.isString(value)
          _.set($json, key, value)
        when value instanceof Date
          _.set($date, key, value.getTime())

    ctx.body = {$json, $date}