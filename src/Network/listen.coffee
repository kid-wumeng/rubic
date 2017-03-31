Koa = require('koa')
cors = require('koa2-cors')
compress = require('koa-compress')


module.exports = (cfg) ->

  app = new Koa()

  app.use(cors({
    origin: '*'
    allowMethods: ['POST']
    exposeHeaders: ['Rubic-O-Data-Type', 'Rubic-O-Token']
  }))

  app.use(compress())

  app.use(@callback.bind(@))

  app.listen(3000)