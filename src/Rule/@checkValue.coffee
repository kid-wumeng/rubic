commonMust = require('./commonMust')
commonEnum = require('./commonEnum')
commonCustom = require('./commonCustom')
booleanType = require('./booleanType')
numberType = require('./numberType')
numberMin = require('./numberMin')
numberMax = require('./numberMax')
stringType = require('./stringType')
stringMin = require('./stringMin')
stringMax = require('./stringMax')
stringFormat = require('./stringFormat')
dateType = require('./dateType')
dateMin = require('./dateMin')
dateMax = require('./dateMax')


module.exports = (rule, value) ->

  commonMust(rule, value)
  commonEnum(rule, value)

  switch rule.type
    when Boolean
      booleanType(value)
    when Number
      numberType(value)
      numberMin(rule, value)
      numberMax(rule, value)
    when String
      stringType(value)
      stringMin(rule, value)
      stringMax(rule, value)
      stringFormat(rule, value)
    when Date
      dateType(value)
      dateMin(rule, value)
      dateMax(rule, value)

  commonCustom(rule, value)