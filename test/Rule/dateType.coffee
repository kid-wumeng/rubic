dateType = require('../../src/Rule/dateType')


suite 'Rule.dateType', ->


  test 'Date实例是日期，时间戳不是', ->
    fn1 = -> dateType(new Date())
    fn2 = -> dateType(Date.now())
    fn1.should.not.throw(Error)
    fn2.should.throw(Error)