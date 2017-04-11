module.exports = (rule, value) ->

  check = rule.check

  if check
    result = check(value)

    if result isnt true
      throw "value is invalid in custom-check."