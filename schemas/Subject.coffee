module.exports =

  'type':
    desc: '类型'
    type: String
    must: true
    enum: [
      'animation-tv',
      'animation-ova',
      'animation-movie',
      'animation-web',
      'comic-offprint',
      'comic-short',
      'comic-paint',
      'game-official',
    ]

  'name':
    desc: '中文名'
    type: String
    must: true
    min: 1
    max: 100

  'aliasNames': [{
    desc: '别名'
    type: String
    max: 100
  }]

  'publishDate':
    desc: '发行日期'
    type: Date

  'intro':
    type: String