module.exports =

  'name':
    desc: '昵称'
    type: String
    min: 3
    max: 18
    check: (name) ->
      return /^(?:\w|-|\.|[\u4E00-\u9FA5])+$/.test(name)

  'collectionCount':
    'animation-tv':
      type: Number
      min: 0
      default: 0

  'fans': [{
    join: 'User'
    'id':
      $ref: 'User.id'
  }]