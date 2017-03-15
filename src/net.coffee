_ = require('lodash')
Koa = require('koa')
cors = require('koa2-cors')
asyncBusboy = require('async-busboy')
jwt = require('jwt-simple')
fs = require('fs-extra-promise')
io = require('./io')


$tokenSecret = null


exports.init = (cfg) ->
  $tokenSecret = cfg.tokenSecret
  @listen(cfg)



exports.listen = (cfg) ->
  app = new Koa()
  app.use(cors({
    origin: '*'
    allowMethods: ['POST']
    exposeHeaders: ['rubic-io', 'rubic-token']
  }))
  app.use(@callback)
  # @TODO 端口可配置化
  app.listen(3000)



exports.callback = (ctx) =>
  try
    ioName = ctx.get('rubic-io')
    await @joinData(ctx)
    @decodeToken(ctx)
    await io.call(ioName, ctx)
    @encodeToken(ctx)
    @splitData(ctx)
  catch error
    @handleError(ctx, error)



exports.handleError = (ctx, error) ->
  if typeof(error) is 'string'
    message = error
  else
    message = error.message
  console.log error
  ctx.body = {message}
  ctx.status = 500



exports.joinData = (ctx) ->
  data = {}
  {fields, files} = await asyncBusboy(ctx.req)
  @joinJSONData(data, JSON.parse(fields.$jsonDict))
  @joinDateData(data, JSON.parse(fields.$dateDict))
  await @joinFileData(data, files)
  ctx.data = data



exports.joinJSONData = (data, jsonDict) ->
  for key, value of jsonDict
    _.set(data, key, value)



exports.joinDateData = (data, dateDict) ->
  for key, timeStamp of dateDict
    date = new Date(timeStamp)
    _.set(data, key, date)


exports.joinFileData = (data, fileDict) ->
  for file in fileDict
    buffer = await fs.readFileAsync(file.path)
    buffer.$file = file
    _.set(data, file.fieldname, buffer)



exports.splitData = (ctx) ->
  jsonDict = {}
  dateDict = {}
  cursor = []

  traversal = (node) ->
    type = typeof(node)
    if type is 'boolean' or type is 'number' or type is 'string'
      jsonDict[cursor.join('.')] = node
    else if node instanceof Date
      dateDict[cursor.join('.')] = node.getTime()
    else
      for name of node
        cursor.push(name)
        traversal(node[name])
    cursor.pop()

  traversal(ctx.body)

  ctx.body = JSON.stringify({
    $jsonDict: jsonDict
    $dateDict: dateDict
  })



exports.encodeToken = (ctx) ->
  if ctx.tokenSigned
    if !$tokenSecret
      throw "Token encode error: secret is not found."
    token = jwt.encode(ctx.tokenSigned, $tokenSecret)
    ctx.set('rubic-token', token)



exports.decodeToken = (ctx) ->
  token = ctx.get('rubic-token')
  if token
    if !$tokenSecret
      throw "Token decode error: secret is not found."
    ctx.token = jwt.decode(token, $tokenSecret)