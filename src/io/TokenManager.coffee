jwt = require('jwt-simple')
Error = require('../Error')



class TokenManager



TokenManager.secret = null
TokenManager.dict = null



TokenManager.saveSecret = (secret) ->
  @secret = secret



TokenManager.saveDict = (dict) ->
  @dict = dict



module.exports = TokenManager