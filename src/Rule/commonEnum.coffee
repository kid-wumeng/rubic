module.exports = (rule, value) ->

  if rule.enum
    if !rule.enum.includes(value)
      throw "value not belong to the enumeration,
             should be in [#{rule.enum.join(', ')}],
             current <#{value}>."