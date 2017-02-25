SchemaFormater = require('./SchemaFormater')
DataFormater = require('./DataFormater')


class IOWrapper


IOWrapper.wrap = (ioDefine={}, ctx={}) ->
  @formatSchema(ioDefine)
  return (data={}) ->
    data = DataFormater.formatLinear(data, ioDefine.inSchema)
    ctx = Object.assign({}, ctx)
    ctx.data = data
    ioDefine.io.call(ctx)



IOWrapper.formatSchema = (ioDefine) ->
  ioDefine.inSchema = SchemaFormater.format(ioDefine.inSchema)
  ioDefine.outSchema = SchemaFormater.format(ioDefine.outSchema)




module.exports = IOWrapper