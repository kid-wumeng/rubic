_ = require('lodash')


module.exports = (rule, data, field, opt) ->

  # join's doc (include 'id')
  doc = _.get(data, field)

  if _.isPlainObject(doc)
    if _.isFinite(doc.id)

      # join's model
      model = @dict[rule.join]
      # join's doc
      doc = await model.findOne(doc.id, opt)

      _.set(data, field, doc)