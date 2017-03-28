module.exports =

  'email':
    desc: '登录邮箱'
    type: String
    max: 100
    format: 'email'

  'name':
    desc: '昵称'
    type: String
    min: 3
    max: 18
    check: (name) ->
      return /^(?:\w|-|\.|[\u4E00-\u9FA5])+$/.test(name)

  'collectionCount':
    'total':
      type: Number
      min: 0
      default: 0
    'animation-tv':
      type: Number
      min: 0
      default: 0
    'animation-ova':
      type: Number
      min: 0
      default: 0
    'animation-web':
      type: Number
      min: 0
      default: 0
    'animation-movie':
      type: Number
      min: 0
      default: 0
      default: 0
    'comic-offprint':
      type: Number
      min: 0
      default: 0
    'comic-short':
      type: Number
      min: 0
      default: 0
    'comic-paint':
      type: Number
      min: 0
      default: 0
    'game-official':
      type: Number
      min: 0
      default: 0