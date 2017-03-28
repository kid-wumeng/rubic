countStringByWidth = require('../../src/Helper/@countStringByWidth')


suite 'Helper.countStringByWidth', ->


  test '计数正常', ->
    countStringByWidth('abc').should.eql(3)
    countStringByWidth('龙').should.eql(2)
    countStringByWidth('abc龙').should.eql(5)