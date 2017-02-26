SchemaManager = require('./SchemaManager')
DataFormater = require('./DataFormater')
DataChecker = require('./DataChecker')



class IOWrapper



IOWrapper.wrap = (ioDefine={}, dictIO) ->
  @formatSchema(ioDefine)
  {iSchema, oSchema, io} = ioDefine

  ctx = {}
  ctx.io = dictIO

  return (inData={}) ->
    inData = DataFormater.format(inData, iSchema)
    DataChecker.check(inData, iSchema)
    outData = await io.call(ctx, inData)
    outData = DataFormater.format(outData, oSchema)
    return outData



IOWrapper.formatSchema = (ioDefine) ->
  ioDefine.iSchema = SchemaManager.formatIOSchema(ioDefine.iSchema)
  ioDefine.oSchema = SchemaManager.formatIOSchema(ioDefine.oSchema)



module.exports = IOWrapper