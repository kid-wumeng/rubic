TokenModem = require('./TokenModem')
Error = require('../Error')



class TokenChecker



TokenChecker.check = (token, ioDefine) ->
  if !ioDefine.token
    return
  token = TokenModem.decode(token)
  @checkRequire(token, ioDefine)
  @checkType(token, ioDefine)
  @checkExpires(token, ioDefine)



TokenChecker.checkRequire = (token, ioDefine) ->
  if !token
    throw new Error.TOKEN_CHECK_FAILED_REQUIRE()



TokenChecker.checkType = (token, ioDefine) ->
  if ioDefine.token[token.$type] isnt true
    throw new Error.TOKEN_CHECK_FAILED_TYPE



TokenChecker.checkExpires = (token, ioDefine) ->
  if token.$expires < Date.now()
    throw new Error.TOKEN_CHECK_FAILED_EXPIRES



module.exports = TokenChecker