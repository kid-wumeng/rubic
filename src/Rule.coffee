fs = require('fs-promise')



# 文件类型
exports.fileType = (rule, key, file) ->

  ReadStream = require('fs').ReadStream

  isReadStream = file instanceof ReadStream
  if !isReadStream
    throw "Data check error: '#{key}' should be a File (fs.ReadStream)."



# 文件MIME类型
exports.fileMIME = (rule, key, file) ->

  if rule.mime
    if !rule.mime.includes(file.mime)
      throw "Data check error: mime of file '#{key}' should be in [#{rule.mime.join(', ')}]."



# 文件大小
exports.fileSize = (rule, key, file) ->

  min = rule.min
  max = rule.max

  if min or max
    min ?= -Infinity
    max ?= +Infinity

    stat = await fs.stat(file.path)
    size = stat.size

    if size < min
      throw "Data check error: size of file '#{key}' should be >= #{min/1024} kb."
    if size > max
      throw "Data check error: size of file '#{key}' should be <= #{max/1024} kb."