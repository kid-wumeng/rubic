colors = require('colors')
Koa = require('koa')
cors = require('koa2-cors')
asyncBusboy = require('async-busboy')
DataParser = require('./DataParser')
IOCaller = require('../io/IOCaller')
Error = require('../Error')



class HTTPServer



HTTPServer.listen = (port) ->
  app = new Koa()
  app.use(cors({
    origin: '*'
    allowMethods: ['POST']
    exposeHeaders: ['rubic-io', 'rubic-token']
  }))
  app.use(@callback)
  app.listen(3000)



HTTPServer.callback = (ctx) ->
  io = ctx.get('rubic-io')
  token = ctx.get('rubic-token')
  try
    data = await DataParser.combine(ctx)
    {data, token} = await IOCaller.call(io, {data, token})
    {jsonDict, dateDict} = DataParser.split(data)
    ctx.body = {jsonDict, dateDict}
    if token
      ctx.set('rubic-token', token)
  catch error
    if error instanceof Error.TOKEN_CHECK_FAILED_EXPIRES
      ctx.set('rubic-token-expires', true)
    if typeof(error) is 'string'
      message = error
    else
      message = error.message
    console.log error.toString().red
    ctx.body = {message}
    ctx.status = 500



module.exports = HTTPServer