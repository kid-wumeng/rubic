module.exports = (rule, value) ->

  max = rule.max ? Infinity

  if rule.countString(value) > max
    throw "value's length should be <= #{max}, current #{value}."