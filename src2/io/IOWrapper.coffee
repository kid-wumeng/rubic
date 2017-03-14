SchemaManager = require('./SchemaManager')
TokenModem = require('./TokenModem')
DataFormater = require('./DataFormater')
DataChecker = require('./DataChecker')
DB = require('../database/MongoDB/DB')



class IOWrapper



IOWrapper.wrap = (ioDefine={}, dictIO) ->
  @formatSchema(ioDefine)
  {iSchema, oSchema, io} = ioDefine

  if io.constructor.name is 'AsyncFunction'
    return (inData={}) ->
      ctx = @
      IOWrapper.loadContextProperties({dictIO, ctx})
      inData = DataFormater.format(inData, iSchema)
      DataChecker.check(inData, iSchema)
      outData = await io.call(ctx, inData)
      outData = DataFormater.format(outData, oSchema)
      # @TODO 临时策略
      outData ?= {}
      outData.$ctx = ctx
      return outData
  else
    return (inData={}) ->
      ctx = @
      IOWrapper.loadContextProperties({dictIO, ctx})
      inData = DataFormater.format(inData, iSchema)
      DataChecker.check(inData, iSchema)
      outData = io.call(ctx, inData)
      outData = DataFormater.format(outData, oSchema)
      # @TODO 临时策略
      outData ?= {}
      outData.$ctx = ctx
      return outData



IOWrapper.loadContextProperties = ({dictIO, ctx}) ->
  ctx.io = dictIO
  ctx.in = {}
  ctx.out = {}
  ctx.signToken = (type, data) ->
    ctx.out.token = TokenModem.encode(type, data)
  ctx.table = (tableName) ->
    return DB.table(tableName)



IOWrapper.formatSchema = (ioDefine) ->
  ioDefine.iSchema = SchemaManager.formatIOSchema(ioDefine.iSchema)
  ioDefine.oSchema = SchemaManager.formatIOSchema(ioDefine.oSchema)



module.exports = IOWrapper