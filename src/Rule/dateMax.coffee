module.exports = (rule, value) ->

  if rule.max
    if value.getTime() > rule.max.getTime()
      throw new Error()