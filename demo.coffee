Core = require('./src/Core')



Core.init({
  dir:
    io: "#{__dirname}/demo/io"
    schema: "#{__dirname}/demo/schemas"
  tokenSecret: 'kid'
  token:
    user: 60
  database:
    name: 'test'
})