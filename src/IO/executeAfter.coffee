module.exports = (ctx, oData, define) ->

  {oSchema} = define

  if oSchema
    return oData
  else
    return undefined