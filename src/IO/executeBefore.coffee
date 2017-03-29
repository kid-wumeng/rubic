_ = require('lodash')
Schema = require('../Schema')


module.exports = (io, iDataArray) ->

  { iSchemaArray } = io

  iDataArrayFiltered = []

  for schema, i in iSchemaArray
    data = iDataArray[i]
    data = Schema.filter(schema, data, {
      check: true
    })
    iDataArrayFiltered.push(data)

  return iDataArrayFiltered