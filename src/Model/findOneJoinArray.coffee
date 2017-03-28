_ = require('lodash')


module.exports = (rule, data, field, opt) ->

  # join's docs (include 'id')
  docs = _.get(data, field)

  if _.isArray(docs)

    # join's model
    model = @dict[rule.join]

    # join's doc-ids
    ids = []
    for doc in docs
      if _.isPlainObject(doc)
        if _.isFinite(doc.id)
          ids.push(doc.id)
          
    ids = _.uniq(ids)

    # join's docs
    docs = await model.find({
      'id':
        $in: ids
    }, opt)

    _.set(data, field, docs)