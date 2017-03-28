reference = require('../../src/Schema/@reference')


suite 'Schema.reference', ->


  test '直接引用模式', ->
    User =
      'name':
        type: String
    Post =
      'user':
        $ref: 'User'
      'content':
        type: String

    dict = { User, Post }
    PostComplete = reference(Post, dict)

    PostComplete.should.eql({
      'user':
        'name':
          type: String
      'content':
        type: String
    })



  test '直接引用属性', ->
    User =
      'name':
        type: String
    Post =
      'user':
        'name':
          $ref: 'User.name'
      'content':
        type: String

    dict = { User, Post }
    PostComplete = reference(Post, dict)

    PostComplete.should.eql({
      'user':
        'name':
          type: String
      'content':
        type: String
    })



  test '间接引用模式', ->
    Job =
      'salary':
        type: Number
    User =
      'name':
        type: String
      'job':
        $ref: 'Job'
    Post =
      'user':
        'job':
          $ref: 'User.job'
      'content':
        type: String

    dict = { Job, User, Post }
    PostComplete = reference(Post, dict)

    PostComplete.should.eql({
      'user':
        'job':
          'salary':
            type: Number
      'content':
        type: String
    })



  test '间接引用属性', ->
    Job =
      'salary':
        type: Number
    User =
      'name':
        type: String
      'salary':
        $ref: 'Job.salary'
    Post =
      'user':
        'salary':
          $ref: 'User.salary'
      'content':
        type: String

    dict = { Job, User, Post }
    PostComplete = reference(Post, dict)

    PostComplete.should.eql({
      'user':
        'salary':
          type: Number
      'content':
        type: String
    })