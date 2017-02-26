colors = require('colors')
Koa = require('koa')
cors = require('koa2-cors')
asyncBusboy = require('async-busboy')
DataParser = require('./DataParser')
IOCaller = require('../io/IOCaller')



class HTTPServer



HTTPServer.listen = (port) ->
  app = new Koa()
  app.use(cors({origin: '*'}))
  app.use(@callback)
  app.listen(3000)



HTTPServer.callback = (ctx) ->
  data = await DataParser.parse(ctx)
  try
    ctx.body = await IOCaller.call('findBook', data)
  catch error
    console.log error.stack.red



module.exports = HTTPServer