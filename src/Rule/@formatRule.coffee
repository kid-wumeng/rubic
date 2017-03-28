Helper = require('../Helper')


module.exports = (rule) ->

  rule = Object.assign({}, rule)

  rule.countString ?= 'width'
  switch rule.countString
    when 'width'  then rule.countString = Helper.countStringByWidth
    when 'length' then rule.countString = Helper.countStringByLength