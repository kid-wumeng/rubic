module.exports = (rule, value) ->

  min = rule.min ? -Infinity

  if rule.countString(value) < min
    throw new Error()