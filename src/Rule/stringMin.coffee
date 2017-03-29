module.exports = (rule, value) ->

  min = rule.min ? -Infinity

  if rule.countString(value) < min
    throw "value's length should be >= #{min}, current #{value}."