IOWrapper = require('./IOWrapper')



class IOManager



IOManager.dictIODefine = null
IOManager.dictIO = null
IOManager.dictIOPublic = null



IOManager.save = (dictIODefine) ->
  @dictIODefine = {}
  for name, ioDefine of dictIODefine
    if name[0] is '@'
      name = name.slice(1)
      ioDefine.public = true
    @dictIODefine[name] = ioDefine



IOManager.format = () ->
  @dictIO = {}
  @dictIOPublic = {}
  for name, ioDefine of @dictIODefine
    io = IOWrapper.wrap(ioDefine, @dictIO)
    if ioDefine.public
      @dictIO[name] = io
      @dictIOPublic[name] = io
    else
      @dictIO[name] = io



module.exports = IOManager