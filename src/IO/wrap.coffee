_ = require('lodash')
Schema = require('../Schema')


module.exports = (define) ->


  executeBefore = @executeBefore
  executeAfter  = @executeAfter


  # 实际的执行体
  fn = define.io


  if fn.constructor.name is 'AsyncFunction'
    return (data) ->
      data = executeBefore(@, data, define)
      data = await fn.call(@, data)
      data = executeAfter(@, data, define)
      return data


  else
    return (data) ->
      data = executeBefore(@, data, define)
      data = fn.call(@, data)
      data = executeAfter(@, data, define)
      return data