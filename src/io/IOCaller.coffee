Error = require('../Error')
IOManager = require('./IOManager')



class IOCaller



IOCaller.call = (name, data) ->
  ioDefine = IOManager.dictIODefine[name]
  if ioDefine and ioDefine.public
    io = IOManager.dictIO[name]
    return await io(data)
  else
    throw new Error.IO_NOT_FOUND({ioName: name})



module.exports = IOCaller