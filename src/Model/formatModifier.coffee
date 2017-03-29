_ = require('lodash')


# @REVIEW 修改值的check？
module.exports = (modifier) ->

  modifier ?= {}
  modifier = Object.assign({}, modifier)

  modifier.$set =
    updateDate: new Date()

  for key, value of modifier

    # $修改器，比如$inc, $push ... 直接通过
    if key[0] is '$'
      $key = key
      # @TODO 不是Object时报错
      if _.isPlainObject(value)
        # 不能修改id
        modifier[$key] = _.omit(value, 'id')

    # 普通字段，一律包裹进$set然后清除
    else
      modifier.$set[key] = value
      delete modifier[key]

  # 不能修改id
  delete modifier.$set['id']

  return modifier