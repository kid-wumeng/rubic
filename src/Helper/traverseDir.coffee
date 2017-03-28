fs = require('fs')
path = require('path')



# callback(file)
# file属性参考：https://nodejs.org/dist/latest-v7.x/docs/api/path.html#path_path_parse_path

module.exports = (dirPath, callback) ->

  childNames = fs.readdirSync(dirPath)

  for childName in childNames

    childPath = "#{dirPath}/#{childName}"
    childStat = fs.statSync(childPath)

    if childStat.isFile()
      file = path.parse(childPath)
      callback(file)

    if childStat.isDirectory()
      @traverseDir(childPath, callback)