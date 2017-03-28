fs = require('fs')
path = require('path')



# 假设有2个文件：'/dir/user.js' 与 '/dir/shop/book.js'
# 传入参数：dirPath = '/dir'
# 返回字典：{'user': node-module, 'shop.book': node-module}
exports.requireDir = (dirPath) ->
  moduleDict = {}
  reg = new RegExp("^#{dirPath}/")
  @traverseDir dirPath, (file) ->
    absolutePath = "#{file.dir}/#{file.name}"
    relativePath = absolutePath.replace(reg, '')
    moduleName = relativePath.replace(/\//g, '.')
    moduleDict[moduleName] = require(absolutePath)
  return moduleDict



# callback(file)
# file属性参考：https://nodejs.org/dist/latest-v7.x/docs/api/path.html#path_path_parse_path
exports.traverseDir = (dirPath, callback) ->
  childNames = fs.readdirSync(dirPath)
  for childName in childNames
    childPath = "#{dirPath}/#{childName}"
    childStat = fs.statSync(childPath)
    if childStat.isFile()
      file = path.parse(childPath)
      callback(file)
    if childStat.isDirectory()
      @traverseDir(childPath, callback)



exports.isEmailAddress = (value) ->
  return /^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$/.test(value)



exports.countCharByWidth = (string) ->
  count = 0
  for char, i in string
    code = string.charCodeAt(i)
    count += if code <= 255 then 1 else 2
  return count