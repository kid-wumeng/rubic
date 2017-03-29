module.exports = (rule, value) ->

  check = rule.check

  if check

    if check.constructor.name is 'AsyncFunction'
      result = await check(value)
    else
      result = check(value)

    if result isnt true
      throw "value is invalid in custom-check."