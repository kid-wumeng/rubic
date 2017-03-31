module.exports = (name, ctx) ->

  io = @dict[name]

  if !io
    throw "io <#{name}> is not found"

  if !io.define.isPublic
    throw "io <#{name}> is not public"

  @readyContext(ctx)

  ctx.response.data = await io.call(ctx, ctx.request.data)