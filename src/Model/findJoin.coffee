_ = require('lodash')


module.exports = (schema, datas, join) ->

  for field, opt of join

    if opt is true
      opt = {}

    rule = _.get(schema, field)

    if _.isPlainObject(rule)
      await @findJoinOne(rule, datas, field, opt)

    else if _.isArray(rule)
      rule = rule[0]
      await @findJoinArray(rule, datas, field, opt)

    else
      throw "规则不存在"