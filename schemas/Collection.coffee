module.exports =

  'user.id':
    $ref: 'User.id'
  'user':
    join: 'User'

  'subject.id':
    $ref: 'Subject.id'
  'subject':
    join: 'Subject'

  'subScore':
    'story':
      type: Boolean
      default: false
    'image':
      type: Boolean
      default: false
    'music':
      type: Boolean
      default: false
    'play':
      type: Boolean
      default: false

  'comment':
    type: String
    max: 10000