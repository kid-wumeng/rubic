jwt = require('jwt-simple')


module.exports = (ctx) ->

  token = ctx.get('Rubic-I-Token')
  if token
    ctx.iToken = jwt.decode(token, @tokenSecret)