IO = require('../IO')


module.exports = (ctx) ->

  try
    # '/shop.findBook' -> 'shop.findBook'
    name = ctx.path.slice(1)

    await @decodeDataArray(ctx)
    await @decodeToken(ctx)

    await IO.callByRequest(name, ctx)

    await @encodeData(ctx)
    await @encodeToken(ctx)

  catch error
    @handleError(ctx, error)