_ = require('lodash')


module.exports = (tokenDict, type, payload={}) ->

  if !tokenDict[type]
    throw "token-type '#{type}' is not configured."

  if !_.isPlainObject(payload)
    throw "token-payload should be a plain-object."

  # 计算失效时间点）
  days = tokenDict[type]
  milliSeconds = parseInt(days * 24 * 60 * 60 * 1000)
  expires = Date.now() + milliSeconds

  # $type与$expires是特殊键，开发者不应该使用）
  token = Object.assign({}, payload)
  token.$type = type
  token.$expires = expires

  ctx.response.token = token