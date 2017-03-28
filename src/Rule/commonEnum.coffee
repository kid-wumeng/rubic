module.exports = (rule, value) ->

  if rule.enum
    if !rule.enum.includes(value)
      throw new Error()