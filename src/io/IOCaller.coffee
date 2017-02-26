IOManager = require('./IOManager')



class IOCaller



IOCaller.call = (name, data) ->
  ioDefine = IOManager.dictIODefine[name]
  if ioDefine and ioDefine.public
    io = IOManager.dictIO[name]
    return await io(data)
  else
    # @TODO Error
    throw '无此API'



module.exports = IOCaller