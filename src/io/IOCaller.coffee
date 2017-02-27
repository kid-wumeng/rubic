Error = require('../Error')
IOManager = require('./IOManager')
TokenChecker = require('./TokenChecker')



class IOCaller



IOCaller.call = (name, {data, token}) ->
  ioDefine = IOManager.dictIODefine[name]
  # 检查是否为公开IO
  if !ioDefine or ioDefine.public isnt true
    throw new Error.IO_NOT_FOUND({ioName: name})
  # 检查令牌
  TokenChecker.check(token, ioDefine)
  # 获取并调用IO
  io = IOManager.dictIO[name]
  return await io(data)



module.exports = IOCaller