module.exports = (rule, value) ->

  @commonMust(rule, value)
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

  commonCustom(rule, value)