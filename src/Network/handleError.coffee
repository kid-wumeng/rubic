module.exports = (ctx, error) ->

  if typeof(error) is 'string'
    message = error
  else
    message = error.message

  console.log error

  ctx.body = {message}
  ctx.status = 500