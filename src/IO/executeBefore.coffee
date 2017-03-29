_ = require('lodash')
Schema = require('../Schema')
checkToken = require('./checkToken')


module.exports = (ctx, iDataArray, define) ->


  { name, iSchemaArray } = define


  # io调用链压入io名
  ctx.rubicIOCallChain.push(define.name)


  # 令牌校验
  checkToken(ctx, define)


  # 数据校验
  iDataArrayFiltered = []

  for schema, i in iSchemaArray
    data = iDataArray[i]
    data = Schema.filter(schema, data, {
      check: true
    })
    iDataArrayFiltered.push(data)


  return iDataArrayFiltered