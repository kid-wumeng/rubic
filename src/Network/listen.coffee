Koa = require('koa')
cors = require('koa2-cors')
compress = require('koa-compress')
bodyParser = require('koa-bodyparser')


module.exports = (cfg) ->

  app = new Koa()

  app.use(cors({
    origin: '*'
    allowMethods: ['POST']
    exposeHeaders: ['Rubic-Token']
  }))

  app.use(bodyParser({
    enableTypes: ['json']
    jsonLimit: '2mb'
  }))

  app.use(compress())

  app.use(@callback.bind(@))

  app.listen(3000)