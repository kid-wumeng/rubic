_ = require('lodash')
Helper = require('../Helper')


module.exports = (rule, datas, field, opt) ->

  # 1. 收集
  ids = []

  ###
    记录有效的联合文档
    key是文档所属data的数组索引
    value无意义（始终为true）
    本词典的主要作用：分配数据时不必再一次判断有效性
    @example
    validDict =
      '3': true
    说明 datas[5]的join-doc有效
  ###
  validDict = {}

  for data, i in datas
    # join's doc (include 'id')
    doc = _.get(data, field)

    if _.isPlainObject(doc)
      if _.isFinite(doc.id)
        ids.push(doc.id)
        validDict[i] = true

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
      # join's doc
      doc = _.get(data, field)
      doc = dict[doc.id]

      _.set(data, field, doc)