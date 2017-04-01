rubic = require('./src')


do ->
  await rubic.init({

    dir:
      schema: "#{__dirname}/demo/schemas"
      model: "#{__dirname}/demo/models"
      io: "#{__dirname}/demo/io"

    database:
      name: 'orz-world'

    tokenSecret: 'abc'
    token:
      user: 180
      admin: 10
  })