module.exports =


  'email':
    type: String
    max: 100
    format: 'email'
    desc: '登录邮箱'


  'password':
    type: String
    desc: '密码'


  'name':
    type: String
    min: 3
    max: 18
    check: (name) -> /^(?:\w|-|\.|[\u4E00-\u9FA5])+$/.test(name)
    desc: '昵称'

  'namePinyin':
    type: String

  'namePinyinFirst':
    type: String


  'motto':
    type: String
    max: 200
    desc: '格言'
    default: ''


  'feedCount':
    type: Number
    min: 0
    default: 0


  'idolCount':
    type: Number
    min: 0
    default: 0

  'fanCount':
    type: Number
    min: 0
    default: 0


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