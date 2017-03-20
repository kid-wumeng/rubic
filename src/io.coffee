_ = require('lodash')
helper = require('./helper')
schema = require('./schema')
model = require('./model')
redis = require('./redis')



$ioDefineDict = {}
$ioDict = {}
$tokenDict = {}



exports.init = (cfg) ->
  # 以下3个方法有依赖关系，调用顺序不能更改
  @createIODefineDict(cfg)
  @formatIODefineDict()
  @createIODict()
  @createTokenDict(cfg)



exports.createIODefineDict = (cfg) ->
  ioDefineDict = helper.requireDir(cfg.dir.io)
  for name, ioDefine of ioDefineDict
    if @isPublic(name)
      ioDefine.public = true
      name = @formatIOName(name)
    $ioDefineDict[name] = ioDefine



exports.isPublic = (name) ->
  index = name.lastIndexOf('.')
  return name[index+1] is '@'



exports.formatIOName = (name) ->
  index = name.lastIndexOf('.')
  letters = name.split('')
  letters.splice(index+1, 1)
  return letters.join('')



exports.formatIODefineDict = ->
  for name, ioDefine of $ioDefineDict
    @referenceISchema(ioDefine)
    schema.handleArrayRules(ioDefine.iSchema)



exports.referenceISchema = (ioDefine) ->
  if ioDefine.iSchema
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



exports.createTokenDict = (cfg) ->
  $tokenDict = cfg.token ? {}



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
  ioDefine = $ioDefineDict[name]
  if !ioDefine
    throw "IO call error: io '#{name}' is not found."
  if !ioDefine.public
    throw "IO call error: io '#{name}' is not public."
  @checkToken(ctx, ioDefine)
  @readyContext(ctx)
  io = _.get(ctx.io, name)
  # @REVIEW 暂时只在外部请求调用时验证规则，是否需要有个可选项，扩展到每次调用？
  iSchema = $ioDefineDict[name].iSchema
  if iSchema
    ctx.data = schema.filter(iSchema, ctx.data)
  data = ctx.data
  await schema.check(iSchema, data)
  # 举例：@call('findBook', ['john'])
  if Array.isArray(data)
    await io(data...)
  # 举例：@call('findBook', {author: 'john'})
  else
    await io(data)



###
  check the token validity.

  @param {Object} ctx
  @param {Object} ioDefine
###

exports.checkToken = (ctx, ioDefine) ->
  if ioDefine.token
    if !ctx.token
      throw "Token check error: lack token."

    type = ctx.token.$type
    if !ioDefine.token[type]
      throw "Token check error: is not allowed token type."

    expires = ctx.token.$type
    if expires < Date.now()
      # @TODO 过期处理
      throw "Token check error: token has expired."



###
  ctx本身是koa的中间件上下文，但会挂载一部分rubic的属性和方法
  无论调用链如何复杂，一次请求/响应之间的io们都共享同一个ctx
  ctx.data属性始终是请求数据（除非开发者修改）

  @param {Object} ctx
###

exports.readyContext = (ctx) ->
  # bind ctx to each io.
  ctx.io = {}
  for name, io of $ioDict
    io = io.bind(ctx)
    _.set(ctx.io, name, io)

  ctx.model = model.getModelDict()

  ctx.redis = redis.client()

  ctx.signToken = @signToken.bind(ctx)



###
sign a token to response.
there is valid only of the last call in io-chain.
@param {string} type - such as 'user', 'admin', ... config by user
@param {Object} payload - data from user.
###

exports.signToken = (type, payload={}) ->
  # $type: must in config.yml
  if not $tokenDict[type]
    throw "Token sign error: token's type '#{type}' is not found in config."
  payload.$type = type

  # $expires: a timestamp in the future
  days = $tokenDict[type]
  milliSeconds = parseInt(days * 24 * 60 * 60 * 1000)
  expires = Date.now() + milliSeconds
  payload.$expires = expires

  @tokenSigned = payload