module.exports = (rule, value) ->

  if rule.min
    if value.getTime() < rule.min.getTime()
      throw new Error()