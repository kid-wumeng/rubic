_ = require('lodash')



###
  @example
  array = [{id: 1, name: 'kid'}, {id: 2, name: 'wumeng'}]
  key = 'id'

  =>
  dict = {
    '1':
      id: 1
      name: 'kid'
    '2':
      id: 1
      name: 'wumeng'
  }
###

module.exports = (array, key) ->

  dict = {}

  for item in array
    value = _.get(item, key)
    dict[value] = item

  return dict