module.exports = (rule, value) ->

  {min} = rule

  if min
    if value.getTime() < min.getTime()
      throw "value should be >= #{min}, current #{value}."