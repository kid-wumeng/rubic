jwt = require('jwt-simple')


module.exports = (ctx) ->

  if ctx.oToken
    token = jwt.encode(ctx.oToken, @tokenSecret)
    ctx.set('Rubic-O-Token', token)