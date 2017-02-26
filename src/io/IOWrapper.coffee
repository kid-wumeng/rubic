SchemaManager = require('./SchemaManager')
DataFormater = require('./DataFormater')



class IOWrapper



IOWrapper.wrap = (ioDefine={}, dictIO) ->
  @formatSchema(ioDefine)
  ctx = {}
  ctx.io = dictIO
  return (data={}) ->
    data = DataFormater.format(data, ioDefine.inSchema)
    ioDefine.io.call(ctx, data)



IOWrapper.formatSchema = (ioDefine) ->
  ioDefine.inSchema = SchemaManager.formatIOSchema(ioDefine.inSchema)
  ioDefine.outSchema = SchemaManager.formatIOSchema(ioDefine.outSchema)



module.exports = IOWrapper