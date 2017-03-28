rubic = require('./src')


rubic.init({
  dir:
    io: "#{__dirname}/io"
    schema: "#{__dirname}/schemas"
  tokenSecret: 'i am coding'
  token:
    user: 60
    admin: 10
  database:
    name: 'orz-world'
})