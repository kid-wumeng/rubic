_ = require('lodash')


module.exports = (query) ->

  query ?= {}

  if _.isFinite(query)
    id = query
    query = {id}

  query = Object.assign({}, query)

  query.removeDate = {$exists: false}
  
  return query