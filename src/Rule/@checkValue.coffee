module.exports = (rule, value) ->

  try

    @commonMust(rule, value)

    # 空值通过must校验后直接放行
    if value is undefined
      return

    @commonEnum(rule, value)

    switch rule.type
      when Boolean
        @booleanType(value)
      when Number
        @numberType(value)
        @numberMin(rule, value)
        @numberMax(rule, value)
      when String
        @stringType(value)
        @stringMin(rule, value)
        @stringMax(rule, value)
        @stringFormat(rule, value)
      when Date
        @dateType(value)
        @dateMin(rule, value)
        @dateMax(rule, value)
      when Buffer
        @bufferType(value)
        @bufferMin(rule, value)
        @bufferMax(rule, value)
        @bufferMime(rule, value)
      when Buffer
        @objectType(value)

    @commonCustom(rule, value)

  catch error
    throw "<#{rule.keyAbs}>: #{error}"