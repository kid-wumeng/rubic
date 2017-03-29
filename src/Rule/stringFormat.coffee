isEmailAddress = require('../Helper/@isEmailAddress')


module.exports = (rule, value)->

  switch rule.format

    when 'email'
      if !isEmailAddress(value)
        throw "value should be a email-address."