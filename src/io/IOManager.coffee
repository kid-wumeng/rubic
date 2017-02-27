IOWrapper = require('./IOWrapper')



class IOManager



IOManager.dictIODefine = null
IOManager.dictIO = null



IOManager.save = (dictIODefine) ->
  @dictIODefine = {}
  for name, ioDefine of dictIODefine
    if name[0] is '@'
      name = name.slice(1)
      ioDefine.public = true
    @dictIODefine[name] = ioDefine



IOManager.format = () ->
  @dictIO = {}
  for name, ioDefine of @dictIODefine
    io = IOWrapper.wrap(ioDefine, @dictIO)
    @dictIO[name] = io



module.exports = IOManager