jwt = require('jwt-simple')
Error = require('../Error')
TokenManager = require('./TokenManager')



class TokenModem



TokenModem.encode = (type, data={}) ->
  secret = TokenManager.secret
  days = TokenManager.dict[type]
  if !secret
    throw new Error.TOKEN_SECRET_NOT_FOUND({type})
  if !days
    throw new Error.TOKEN_TYPE_NOT_FOUND({type})
  data.$type = type
  data.$expires = Date.now() + parseInt(days * 24 * 60 * 60 * 1000)
  return jwt.encode(data, secret)



TokenModem.decode = (token) ->
  secret = TokenManager.secret
  data = jwt.decode(token, secret)
  return data



module.exports = TokenModem