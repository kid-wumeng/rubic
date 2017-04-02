jwt = require('jwt-simple')


module.exports = (ctx) ->

  tokenString = ctx.get('Rubic-Token')

  if tokenString
    ctx.request.token = jwt.decode(tokenString, @tokenSecret)
  else
    ctx.request.token = {}
    
  ctx.token = ctx.request.token