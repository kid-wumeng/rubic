numberType = require('../../src/Rule/numberType')


suite 'Rule.numberType', ->


  test '非正常数字', ->
    fn1 = -> numberType(Infinity)
    fn2 = -> numberType(-Infinity)
    fn3 = -> numberType(NaN)
    fn1.should.throw(Error)
    fn2.should.throw(Error)
    fn3.should.throw(Error)