_ = require('lodash')
Schema = require('../Schema')


module.exports = (define) ->


  executeBefore = @executeBefore
  executeAfter  = @executeAfter


  # 实际的执行体
  fn = define.io


  if fn.constructor.name is 'AsyncFunction'
    return (iDataArray...) ->
      iDataArray = executeBefore(@, iDataArray, define)
      oData = await fn.call(@, iDataArray...)
      oData = executeAfter(@, oData, define)
      return oData


  else
    return (iDataArray...) ->
      iDataArray = executeBefore(@, iDataArray, define)
      oData = fn.call(@, iDataArray...)
      oData = executeAfter(@, oData, define)
      return oData