SchemaFormater = require('./SchemaFormater')
DataFormater = require('./DataFormater')


class IOWrapper


IOWrapper.wrap = (ioDefine={}, ctx={}) ->
  @formatSchema(ioDefine)
  return (data={}) ->
    data = DataFormater.format(data, ioDefine.inSchema)
    ctx = Object.assign({}, ctx)
    ctx.data = data
    ioDefine.io.call(ctx)



IOWrapper.formatSchema = (ioDefine) ->
  ioDefine.inSchema = SchemaFormater.formatLinear(ioDefine.inSchema)
  ioDefine.outSchema = SchemaFormater.formatLinear(ioDefine.outSchema)




module.exports = IOWrapper