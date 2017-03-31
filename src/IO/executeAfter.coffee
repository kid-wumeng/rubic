module.exports = (ctx, data, define) ->
  
  return if define.oSchema then data else undefined