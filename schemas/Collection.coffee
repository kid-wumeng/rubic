module.exports =

  'user':
    join: 'User'
    'id':
      $ref: 'User.id'
  
  'fans': [{
    join: 'User'
    'id':
      $ref: 'User.id'
  }]