rubic = require('./src')
axios = require('axios')
http = require('http')


do ->

  await rubic.init({
    dir:
      schema: "#{__dirname}/schemas"
      model: "#{__dirname}/models"
      io: "#{__dirname}/io"
    tokenSecret: 'i am coding'
    token:
      user: 60
      admin: 10
    database:
      name: 'orz-world'
  })