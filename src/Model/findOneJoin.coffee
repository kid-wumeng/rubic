_ = require('lodash')


module.exports = (schema, data, join) ->

  for field, opt of join

    if opt is true
      opt = {}

    rule = _.get(schema, field)


    if _.isPlainObject(rule)
      model = rule.join
      model = @dict[model]
      doc = _.get(data, field)
      doc = await model.findOne(doc.id, opt)
      _.set(data, field, doc)

    else if _.isArray(rule)
      model = rule[0].join
      model = @dict[model]
      docs = _.get(data, field)
      ids = docs.map (doc) -> doc.id
      ids = _.uniq(ids)
      docs = await model.find({
        'id':
          $in: ids
      }, opt)
      _.set(data, field, docs)

    else
      throw "规则不存在"