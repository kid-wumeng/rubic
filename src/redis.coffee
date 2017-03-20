redis = require('redis')
bluebird = require('bluebird')



$client = null
$clientWithoutAsync = null



exports.init = (cfg) ->
  @wrapAsyncFunction()
  @connect(cfg)
  @wrapWithoutAsyncFunction()



exports.wrapAsyncFunction = ->
  bluebird.promisifyAll(redis.RedisClient.prototype)
  bluebird.promisifyAll(redis.Multi.prototype)



exports.connect = (cfg) ->
  $client = redis.createClient()



exports.wrapWithoutAsyncFunction = ->
  $clientWithoutAsync = {}
  for name, fn of $client
    if /Async$/.test(name) and typeof(fn) is 'function'
      nameWithoutAsync = name.replace(/Async$/, '')
      $clientWithoutAsync[nameWithoutAsync] = fn.bind($client)



exports.client = ->
  return $clientWithoutAsync