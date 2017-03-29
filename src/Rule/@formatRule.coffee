Helper = require('../Helper')


module.exports = (rule) ->

  if rule.type is String

    rule.countString ?= 'width'

    switch rule.countString
      when 'width'  then rule.countString = Helper.countStringByWidth
      when 'length' then rule.countString = Helper.countStringByLength

  return undefined