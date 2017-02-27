SchemaManager = require('./SchemaManager')
TokenModem = require('./TokenModem')
DataFormater = require('./DataFormater')
DataChecker = require('./DataChecker')



class IOWrapper



IOWrapper.wrap = (ioDefine={}, dictIO) ->
  @formatSchema(ioDefine)
  {iSchema, oSchema, io} = ioDefine

  return (inData={}) ->
    ctx = IOWrapper.createContext({dictIO})
    inData = DataFormater.format(inData, iSchema)
    DataChecker.check(inData, iSchema)

    outData = await io.call(ctx, inData)

    outData = DataFormater.format(outData, oSchema)
    out = ctx.out
    out.data = outData
    return out



IOWrapper.createContext = ({dictIO}) ->
  ctx = {}
  ctx.io = dictIO
  ctx.in = {}
  ctx.out = {}
  ctx.signToken = (type, data) ->
    ctx.out.token = TokenModem.encode(type, data)
  return ctx



IOWrapper.formatSchema = (ioDefine) ->
  ioDefine.iSchema = SchemaManager.formatIOSchema(ioDefine.iSchema)
  ioDefine.oSchema = SchemaManager.formatIOSchema(ioDefine.oSchema)



module.exports = IOWrapper