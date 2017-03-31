_ = require('lodash')
Schema = require('../Schema')
checkToken = require('./checkToken')


module.exports = (ctx, data, define) ->

  # io调用链压入io名
  ctx.rubicIOCallChain.push(define.name)

  # 令牌校验
  checkToken(ctx, define)

  # 数据校验
  data = Schema.filter(define.iSchema, data, {check: true})

  return data