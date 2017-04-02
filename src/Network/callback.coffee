IO = require('../IO')


module.exports = (ctx) ->

  try
    
    # '/shop.findBook' -> 'shop.findBook'
    name = ctx.path.slice(1)

    @decodeData(ctx)
    @decodeToken(ctx)

    await IO.callByRequest(name, ctx)

    @encodeData(ctx)
    @encodeToken(ctx)

  catch error
    @handleError(ctx, error)