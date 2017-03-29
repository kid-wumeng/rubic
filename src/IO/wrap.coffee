_ = require('lodash')
Schema = require('../Schema')


module.exports = (io) ->

  executeBefore = @executeBefore
  executeAfter  = @executeAfter


  # 实际的执行体
  fn = io.io

  if fn.constructor.name is 'AsyncFunction'
    return (iDataArray...) ->
      iDataArray = executeBefore(io, iDataArray)
      oData = await fn.call(@, iDataArray...)
      oData = executeAfter(io, oData)
      return oData

  else
    return (iDataArray...) ->
      iDataArray = executeBefore(io, iDataArray)
      oData = fn.call(@, iDataArray...)
      oData = executeAfter(io, oData)
      return oData