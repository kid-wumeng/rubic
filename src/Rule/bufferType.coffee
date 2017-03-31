_ = require('lodash')


module.exports = (value) ->

  if !(value instanceof Buffer)
    throw "value should be a buffer ( the base64 in front-end )."