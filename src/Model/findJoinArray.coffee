_ = require('lodash')
Helper = require('../Helper')


module.exports = (rule, datas, field, opt) ->

  # 1. 收集
  ids = []

  ###
    记录有效的联合文档
    二维词典
    一维是datas的数组索引
    二维是join-docs的数组索引
    本词典的主要作用：分配数据时不必再一次判断有效性
    @example
    validDict =
      '3':
        '5': true
    说明 datas[3]的join-docs[5]有效
  ###
  validDict = {}

  for data, i in datas
    # join's docs (include 'id')
    docs = _.get(data, field)

    if _.isArray(docs)
      for doc, j in docs
        if _.isPlainObject(doc)
          if _.isFinite(doc.id)
            ids.push(doc.id)
            _.set(validDict, "#{i}.#{j}", true)

  # join's doc-ids
  ids = _.uniq(ids)



  # 2. 读取
  # join's model
  model = @dict[rule.join]

  # join's docs
  docs = await model.find({
    'id':
      $in: ids
  }, opt)



  # 3. 分配
  # join's doc-dict
  dict = Helper.arrayToDict(docs, 'id')

  for data, i in datas
    if validDict[i]
      # join's docs
      docs = _.get(data, field)
      for doc, j in docs
        if validDict[i][j]
          docs[j] = dict[doc.id]

      _.set(data, field, docs)