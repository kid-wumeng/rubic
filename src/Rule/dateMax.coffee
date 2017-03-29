module.exports = (rule, value) ->

  {max} = rule

  if max
    if value.getTime() > max.getTime()
      throw "value should be <= #{max}, current #{value}."