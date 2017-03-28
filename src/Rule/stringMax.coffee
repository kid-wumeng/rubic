module.exports = (rule, value) ->

  max = rule.max ? Infinity

  if rule.countString(value) > max
    throw new Error()