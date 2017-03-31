jwt = require('jwt-simple')


module.exports = (ctx) ->

  token = ctx.response.token

  if token
    tokenString = jwt.encode(token, @tokenSecret)
    ctx.set('Rubic-Token', tokenString)