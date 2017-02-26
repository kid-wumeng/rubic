_ = require('lodash')
asyncBusboy = require('async-busboy')
fs = require('fs-extra-promise')



class DataParser



DataParser.parse = (ctx) ->
  {fields, files} = await asyncBusboy(ctx.req)
  {$jsonDict, $dateDict} = fields
  jsonDict = JSON.parse($jsonDict)
  dateDict = JSON.parse($dateDict)

  data = {}
  for key, value of jsonDict
    _.set(data, key, value)
  for key, value of dateDict
    value = new Date(value)
    _.set(data, key, value)
  for file in files
    buffer = await fs.readFileAsync(file.path)
    _.set(data, file.fieldname, buffer)
  return data



module.exports = DataParser