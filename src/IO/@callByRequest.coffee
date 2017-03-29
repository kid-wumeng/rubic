module.exports = (name, ctx) ->

  io = @dict[name]

  if !io
    throw "io <#{name}> is not found"

  if !io.define.isPublic
    throw "io <#{name}> is not public"

  @readyContext(ctx)

  ctx.oData = await io.call(ctx, ctx.iDataArray...)