module.exports = (io, oData) ->

  {oSchema} = io

  if oSchema
    return oData
  else
    return undefined