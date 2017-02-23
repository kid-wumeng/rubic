co = require('co')
Runtime = require('./src/Runtime')


co(->

  Runtime.start()

).catch((e)->
  console.log e
)