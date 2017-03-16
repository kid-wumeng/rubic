_ = require('lodash')
fileType = require('file-type')
helper = require('./helper')



$schemaDict = {}
$ruleDict = {}



exports.init = (cfg) ->
  # 以下4个方法有依赖关系，调用顺序不能更改
  @createSchemaDict(cfg)
  @createRuleDict()
  @formatRuleDict()
  @formatSchemaDict()



exports.createSchemaDict = (cfg) ->
  $schemaDict = helper.requireDir(cfg.dir.schema)



exports.createRuleDict = ->
  for schemaKey, schema of $schemaDict
    for ruleKey, rule of schema
      # 规则的全限定键名
      ruleKey = "#{schemaKey}.#{ruleKey}"
      $ruleDict[ruleKey] = rule



exports.formatRuleDict = ->
  for key, rule of $ruleDict
    @referenceRecurse(key, rule)



exports.formatSchemaDict = ->
  for key of $schemaDict
    @distillSchema(key)



# 通用规则可能存在引用链，即是说引用的规则可能还引用了其它规则或模式，所以必须递归处理
exports.referenceRecurse = (key, rule) ->
  ref = rule.ref
  if ref
    refRule = $ruleDict[ref]
    refSchema = $schemaDict[ref]
    # 引用单条规则
    if refRule
      $ruleDict[key] = refRule
      # 处理引用链
      @referenceRecurse(key, refRule)
    # 引用整个模式
    else if refSchema
      for refKey, refRule of refSchema
        newKey = "#{key}.#{refKey}"
        $ruleDict[newKey] = refRule
        # 处理引用链
        @referenceRecurse(newKey, refRule)
    else
      throw "Schema reference error: ref '#{ref}' is not found."



# 从$ruleDict中提取某个模式的规则
# 使用本方法的前提是$ruleDict已格式化完毕
# 举例：
# $ruleDict = {
#   'shop.Book.name': ...
#   'shop.Book.author.name': ...
#   'shop.Movie.name': ...
#   'shop.Movie.publishDate': ...
# }
# 若 schemaKey = 'shop.Book'
# 返回 schema = {
#   'name': ...,
#   'author.name': ...
# }
exports.distillSchema = (schemaKey) ->
  $schemaDict[schemaKey] = {}
  schemaKeyReg = new RegExp("^#{schemaKey}.")
  for ruleKey, rule of $ruleDict
    # /^shop.Book./.test('shop.Book.author.name') => true
    # /^shop.Book./.test('shop.Movie.publishDate') => false
    if schemaKeyReg.test(ruleKey) and !rule.ref
      # 'shop.Book.author.name' => 'author.name'
      ruleKey = ruleKey.replace(schemaKeyReg, '')
      # $schemaDict['shop.Book']['author.name'] = ...
      $schemaDict[schemaKey][ruleKey] = rule



exports.getSchema = (name) ->
  schema = $schemaDict[name]
  return Object.assign({}, schema)




###
  本方法专门用于IO模式的引用

  假设有字典：
  $schemaDict = {
    Book:
      'name': ...
      'author.name': ...
    Author:
      'name': ...
  }
  $ruleDict = {
    'Book.name': ...
    'Book.author.name': ...
    'Book.author': {ref: 'Author'}
    'Author.name': ...
  }

  IO引用的模式分为3类：

  1. 直接规则引用，比如：
  iSchema = {
    'book.name': {ref: 'Book.name'}
  }
  直接在$ruleDict中查找即可，引用后成为：
  iSchema = {
    'book.name': ...
  }

  2. 直接模式引用，比如：
  iSchema = {
    'book': {ref: 'Book'}
  }
  直接在$schemaDict中查找即可，但需要挂载到iSchema的命名空间中，引用后成为：
  iSchema = {
    'book.name': ...
    'book.author.name': ...
  }
  之后需删除'book'这条引用属性


  3. 间接模式引用，比如：
  iSchema = {
    'book.author': {ref: 'Book.author'}
  }
  碰到这种情况时，应该先在$ruleDict中找到'Book.author'，即{ref: 'Author'}
  然后根据ref去$schemaDict中查找，再将规则挂载到iSchema的命名空间中，引用后成为：
  iSchema = {
    'book.author.name': ...
  }
  之后需删除'book.author'这条引用属性
###

exports.reference = (schema, key) ->
  ref = schema[key].ref
  # 不处理普通规则
  if !ref
    return
  refRule = $ruleDict[ref]
  if refRule
    if refRule.ref
      # 间接模式引用
      ref = refRule.ref
      refSchema = $schemaDict[ref]
      @referenceSchema(schema, key, refSchema)
    else
      # 直接规则引用
      schema[key] = refRule
      refRule = $ruleDict[ref]
    return
  # 直接模式引用
  refSchema = $schemaDict[ref]
  if refSchema
    @referenceSchema(schema, key, refSchema)
    return
  # 找不到ref相关信息
  throw "Schema reference error: ref '#{ref}' is not found."



exports.referenceSchema = (schema, key, refSchema) ->
  for refKey, refRule of refSchema
    newKey = "#{key}.#{refKey}"
    schema[newKey] = refRule
  # 删除引用属性
  delete schema[key]



exports.handleArrayRules = (schema) ->
  for key, rule of schema
    if key.indexOf('$') > -1
      @handleArrayRule(key, rule)



exports.handleArrayRule = (key, rule) ->
  # for example,
  # key = 'post.comments.$.replies.$.content'

  # parts = ['post.comments', 'replies', 'content']
  parts = key.split(/\.\$\.?/)

  # itemKey = 'content'
  itemKey = parts.pop()

  # arrayKeys = ['post.comments', 'replies']
  arrayKeys = parts

  rule.valueInArray = true
  rule.arrayKeys = arrayKeys
  rule.itemKey = itemKey



exports.filter = (schema, data) ->
  if typeof(schema) is 'string'
    schema = $schemaDict[schema]
  dataFiltered = {}
  for key, rule of schema
    if rule.valueInArray is true
      items = @getItemsInArray(rule, data)
      for item in items
        {key, value} = item
        if value
          _.set(dataFiltered, key, value)
    else
      value = _.get(data, key)
      if value
        _.set(dataFiltered, key, value)
  return dataFiltered



# 规则集
# default {Boolean}         默认值，设置为null或undefined是没意义的
# must    {Boolean}         必要性
# type    {Object}          可选类型：Boolean|Number|String|Buffer|Date
# enum    {Array(*)}        枚举范围
# min     {Number}          Number最小值|String最小长度|Buffer最小长度|Date最小时间戳
# max     {Number}          Number最大值|String最大长度|Buffer最大长度|Date最大时间戳
# format  {String}          字符串格式，暂时只支持'email'
# mimes   {Array[String]}   允许的文件MIME类型，Buffer专用规则
# check   {Function}        开发者自己定义的规则，属性值作为参数传入，返回true/false代表是否通过
exports.check = (schema, data) ->
  if typeof(schema) is 'string'
    schema = $schemaDict[schema]
  for key, rule of schema
    if rule.valueInArray is true
      items = @getItemsInArray(rule, data)
      for item in items
        {key, value} = item
        @checkValue(rule, key, value)
    else
      value = _.get(data, key)
      @checkValue(rule, key, value)



exports.getItemsInArray = (rule, data) ->
  ###
  @example
  rule.arrayKeys = ['post.comments', 'replies']
  rule.itemKey = 'content'
  data =
    post:
      comments: [{
        content: 'c1'
        replies: [{content: 'r1'},{content: 'r2'}]
      },{
        content: 'c2'
        replies: [{content: 'r3'},{content: 'r4'}]
      }]
  ###

  arrayKeys = rule.arrayKeys
  itemKey = rule.itemKey
  deepMax = arrayKeys.length
  deep = 0
  cursor = []
  items = []

  fn = (node) ->
    if deep is deepMax
      if itemKey
        key = "#{cursor.join('.')}.#{itemKey}"
        value = _.get(node, itemKey)
      else
        key = cursor.join('.')
        value = node
      items.push({key, value})
      return

    key = arrayKeys[deep]
    children = _.get(node, key)
    if !children
      return
    deep++
    cursor.push(key)
    for child, i in children
      cursor.push(i)
      fn(child)
      cursor.pop()
    cursor.pop()
    deep--

  fn(data)
  return items



exports.checkValue = (rule, key, value) ->
  @checkMust(rule, key, value)
  if value is undefined
    return
  switch rule.type
    when Boolean then @checkBoolean(rule, key, value)
    when Number then @checkNumber(rule, key, value)
    when String then @checkString(rule, key, value)
    when Buffer then @checkBuffer(rule, key, value)
    when Date then @checkDate(rule, key, value)
  @checkCustom(rule, key, value)



exports.checkMust = (rule, key, value) ->
  if rule.must
    if value is undefined
      throw "Data check error: lack a must prop '#{key}'."



exports.checkCustom = (rule, key, value) ->
  if rule.check
    if rule.check(value) isnt true
      throw "Data check error: '#{key}' custom-check failed."



exports.checkBoolean = (rule, key, value) ->
  if typeof(value) isnt 'boolean'
    throw "Data check error: '#{key}' should be a boolean."



exports.checkNumber = (rule, key, value) ->
  if typeof(value) isnt 'number'
    throw "Data check error: '#{key}' should be a number."
  if rule.enum
    if !rule.enum.includes(value)
      throw "Data check error: '#{key}' should be in [#{rule.enum.join(', ')}]."
  min = rule.min ? -Infinity
  if value < min
    throw "Data check error: length of '#{key}' should be >= #{min}."
  max = rule.max ? Infinity
  if value > max
    throw "Data check error: length of '#{key}' should be <= #{max}."



exports.checkString = (rule, key, value) ->
  if typeof(value) isnt 'string'
    throw "Data check error: '#{key}' should be a string."
  if rule.enum
    if !rule.enum.includes(value)
      throw "Data check error: '#{key}' should be in [#{rule.enum.join(', ')}]."
  min = rule.min ? -Infinity
  # @TODO countChar
  if helper.countCharByWidth(value) < min
    throw "Data check error: length of '#{key}' should be >= #{min}."
  max = rule.max ? Infinity
  # @TODO countChar
  if helper.countCharByWidth(value) > max
    throw "Data check error: length of '#{key}' should be <= #{max}."
  switch rule.format
    when 'email'
      if !helper.isEmailAddress(value)
        throw "Data check error: '#{key}' should be an email address."



exports.checkBuffer = (rule, key, value) ->
  if !(value instanceof Buffer)
    throw "Data check error: '#{key}' should be a Buffer ( File in front-end )."
  mime = fileType(value).mime
  if rule.mime and !rule.mime.includes(mime)
    throw "Data check error: mime of file '#{key}' should be in [#{rule.mime.join(', ')}]."
  min = rule.min ? -Infinity
  if value.length < min
    throw "Data check error: size of file '#{key}' should be >= #{min/1024} kb."
  max = rule.max ? Infinity
  if value.length > max
    throw "Data check error: size of file '#{key}' should be <= #{max/1024} kb."



exports.checkDate = (rule, key, value) ->
  if !(value instanceof Date)
    throw "Data check error: '#{key}' should be a Date."
  # @TODO enum，min，max验证