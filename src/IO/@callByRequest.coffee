module.exports = (name, ctx) ->

  io = @dict[name]

  if !io
    throw "io <#{name}> is not found"

  if !io.isPublic
    throw "io <#{name}> is not public"

  @readyContext(ctx)

  return await io.call(ctx, ctx.iDataArray...)