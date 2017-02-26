Koa = require('koa')
IOCaller = require('../io/IOCaller')



class HTTPServer



HTTPServer.listen = (port) ->
  app = new Koa()
  app.use(@callback)
  app.listen(3000)



HTTPServer.callback = (ctx) ->
  ctx.body = await IOCaller.call('findBook', {id: 8})



module.exports = HTTPServer