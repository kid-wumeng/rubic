stringType = require('../../src/Rule/stringType')


suite 'Rule.stringType', ->


  test '""是字符串', ->
    fn = -> stringType('')
    fn.should.not.throw(Error)