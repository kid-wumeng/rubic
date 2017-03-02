_ = require('lodash')
asyncBusboy = require('async-busboy')
fs = require('fs-extra-promise')



class DataParser



DataParser.combine = (ctx) ->
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



DataParser.split = (data) ->
  traversal = (node) ->
    type = typeof(node)
    if type is 'boolean' or type is 'number' or type is 'string'
      jsonDict[cursor.join('.')] = node
    else if node instanceof Date
      dateDict[cursor.join('.')] = node.getTime()
    else
      for name, child of node
        cursor.push(name)
        traversal(child)
    cursor.pop()
  jsonDict = {}
  dateDict = {}
  cursor = []
  traversal(data)
  return { jsonDict, dateDict }



module.exports = DataParser