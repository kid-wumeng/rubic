_ = require('lodash')
asyncBusboy = require('async-busboy')
Helper = require('../Helper')


module.exports = (ctx) ->


  { fields, files } = await asyncBusboy(ctx.req)
  { $json, $date } = fields


  ctx.iDataArray = []

  # 基本数据
  if $json
    $json = JSON.parse($json)

    Helper.traverseLeaf $json, (key, value) ->
      _.set(ctx.iDataArray, key, value)


  # 日期数据
  if $date
    $date = JSON.parse($date)

    Helper.traverseLeaf $date, (key, timeStamp) ->
      _.set(ctx.iDataArray, key, new Date(timeStamp))


  # 文件数据
  for file in files
    _.set(ctx.iDataArray, file.fieldname, file)