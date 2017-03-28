commonCustom = require('../../src/Rule/commonCustom')


suite 'Rule.commonCustom', ->


  test '异步函数', ->

    check = (value) ->
      return await new Promise (resolve, reject) ->
        setTimeout (->
          if value > 5
            resolve(true)
          else
            resolve(false)
        ), 10

    try
      await commonCustom({check}, 3)
    catch error
      error.should.instanceof(Error)