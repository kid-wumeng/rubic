_ = require('lodash')
Helper = require('../Helper')


module.exports = (schema, datas, join) ->

  for field, opt of join

    if opt is true
      opt = {}

    rule = _.get(schema, field)


    # join单文档
    if _.isPlainObject(rule)
      model = rule.join
      model = @dict[model]
      ids = []
      for data in datas
        doc = _.get(data, field)
        if doc and doc.id
          ids.push(doc.id)

      ids = _.uniq(ids)

      docs = await model.find({
        'id':
          $in: ids
      }, opt)

      dict = Helper.arrayToDict(docs, 'id')

      for data in datas
        doc = _.get(data, field)
        if doc and doc.id
          _.set(data, field, dict[doc.id])





    # join文档数组
    else if _.isArray(rule)
      model = rule[0].join
      model = @dict[model]
      ids = []
      for data in datas
        docs = _.get(data, field)
        if docs
          for doc in docs
            if doc.id
              ids.push(doc.id)

      ids = _.uniq(ids)

      docs = await model.find({
        'id':
          $in: ids
      }, opt)

      dict = Helper.arrayToDict(docs, 'id')

      for data in datas
        docs = _.get(data, field)
        if docs
          for doc, i in docs
            if doc.id
              docs[i] = dict[doc.id]
          _.set(data, field, docs)