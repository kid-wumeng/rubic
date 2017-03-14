helper = require('./helper')
schema = require('./schema')
model = require('./model')



$ioDefineDict = {}
$ioDict = {}



exports.init = (cfg) ->
  # 以下3个方法有依赖关系，调用顺序不能更改
  @createIODefineDict(cfg)
  @formatIODefineDict()
  @createIODict()



exports.createIODefineDict = (cfg) ->
  $ioDefineDict = helper.requireDir(cfg.dir.io)



exports.formatIODefineDict = ->
  for name, ioDefine of $ioDefineDict
    @referenceISchema(ioDefine)



exports.referenceISchema = (ioDefine) ->
  if !ioDefine.iSchema
    ioDefine.iSchema = {}
  # 如果iSchema是数组，则先转为对象
  # [{...}, {...}] => {'0': {...}, '1': {...}}
  if Array.isArray(ioDefine.iSchema)
    iSchemaObject = {}
    for item, i in ioDefine.iSchema
      iSchemaObject[i] = item
    ioDefine.iSchema = iSchemaObject
  # 遍历处理规则的引用
  for key, rule of ioDefine.iSchema
    schema.reference(ioDefine.iSchema, key)



exports.createIODict = ->
  for name, ioDefine of $ioDefineDict
    $ioDict[name] = @wrap(ioDefine)



exports.wrap = (ioDefine) ->
  # io的传参分2种形式
  # 对象传参 io({...})
  # 顺序传参 io(a, b)
  # io内的互调支持任何一种形式
  # 但来自外部请求的调用只支持对象传参
  io = ioDefine.io
  if io.constructor.name is 'AsyncFunction'
    return (args...) ->
      @body = await io.call(@, args...)
  else
    return (args...) ->
      @body = io.call(@, args...)



# 外部请求时才使用本方法
# io内的互调直接使用@io.xxx()即可
exports.call = (name, ctx) ->
  @readyContext(ctx)
  io = ctx.io[name]
  data = ctx.data
  # @REVIEW 暂时只在外部请求调用时验证规则，是否需要有个可选项，扩展到每次调用？
  iSchema = $ioDefineDict[name].iSchema
  schema.check(iSchema, data)
  # 举例：@call('findBook', ['john'])
  if Array.isArray(data)
    await io(data...)
  # 举例：@call('findBook', {author: 'john'})
  else
    await io(data)



# ctx本身是koa的中间件上下文，但会挂载一部分rubic的属性和方法
# 无论调用链如何复杂，一次请求/响应之间的io们都共享同一个ctx
# ctx.data属性始终是请求数据（除非开发者修改）
exports.readyContext = (ctx) ->
  # 挂载绑定了上下文的io表
  ctx.io = {}
  for name, io of $ioDict
    ctx.io[name] = io.bind(ctx)
  # 挂载模型表
  ctx.model = model.getModelDict()