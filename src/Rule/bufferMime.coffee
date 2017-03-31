fileType = require('file-type')


module.exports = (rule, value) ->

  if rule.mime and rule.mime.length > 0

    mime = fileType(value).mime

    if !rule.mime.includes(mime)
      throw "file's mime-type not belong to the limits,
             should be in [#{rule.mime.join(', ')}],
             current <#{mime}>."