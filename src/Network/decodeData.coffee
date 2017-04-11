_ = require('lodash')
Helper = require('../Helper')


module.exports = (ctx) ->

  ctx.request.data = ctx.request.body

  {data} = ctx.request

  if data
    if !_.isPlainObject(data)
      throw "request-data should be a plain-object."
  else
    return

  Helper.traverseLeaf data, (value, key, parent) ->

    if /^\/Date\(\d+\)\/$/.test(value)
      value = value.slice(6, value.length-2)
      timeStamp = parseInt(value)
      value = new Date(timeStamp)

    else if /^\/Base64\(.+\)\/$/.test(value)
      base64 = value.slice(8, value.length-2)
      value = new Buffer(base64, 'base64')

    # 比如： data = {'user.id': 6}
    # 则删除 data['user.id']
    # 替换为 data['user']['id']
    delete parent[key]
    _.set(parent, key, value)