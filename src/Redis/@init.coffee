_ = require('lodash')
redis = require('redis')
bluebird = require('bluebird')


module.exports = (cfg) ->

  bluebird.promisifyAll(redis.RedisClient.prototype)
  bluebird.promisifyAll(redis.Multi.prototype)

  rawClient = redis.createClient()

  @client = {}

  for name, fn of rawClient
    if /Async$/.test(name)
      if _.isFunction(fn)
        name = name.replace(/Async$/, '')
        @client[name] = fn.bind(rawClient)