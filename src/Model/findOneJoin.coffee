_ = require('lodash')


module.exports = (schema, data, join) ->

  for field, opt of join

    if opt is true
      opt = {}

    rule = _.get(schema, field)

    if _.isPlainObject(rule)
      await @findOneJoinOne(rule, data, field, opt)

    else if _.isArray(rule)
      rule = rule[0]
      await @findOneJoinArray(rule, data, field, opt)

    else
      throw "规则不存在"