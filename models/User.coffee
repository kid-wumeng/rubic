module.exports =


  collection: 'User'


  schema:

    $ref: 'User'

    'email':
      desc: '登录邮箱'
      type: String
      max: 100
      format: 'email'
      private: true

    'comment': {
      'replies': [{
        'content':
          type: String
          default: 'bbcc'
      }]
    }