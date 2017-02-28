colors = require('colors')
Koa = require('koa')
cors = require('koa2-cors')
asyncBusboy = require('async-busboy')
DataParser = require('./DataParser')
IOCaller = require('../io/IOCaller')



class HTTPServer



HTTPServer.listen = (port) ->
  app = new Koa()
  app.use(cors({
    origin: '*'
    allowMethods: ['POST']
    exposeHeaders: ['rubik-io', 'rubik-token']
  }))
  app.use(@callback)
  app.listen(3000)



HTTPServer.callback = (ctx) ->
  io = ctx.get('rubik-io')
  token = ctx.get('rubik-token')
  try
    data = await DataParser.parse(ctx)
    {data, token} = await IOCaller.call('findBook', {data, token})
    ctx.body = data
    if token
      ctx.set('rubik-token', token)
  catch error
    if typeof(error) is 'string'
      message = error
    else
      message = error.message
    console.log message.red
    ctx.body = {message}
    ctx.status = 500



module.exports = HTTPServer