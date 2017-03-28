###

  假设有2个文件：
    '/dir/user.js'
    '/dir/shop/book.js'

  传入参数：
    dirPath = '/dir'

  返回字典：
    {'user': node-module, 'shop.book': node-module}

###

module.exports = (dirPath) ->

  dict = {}

  reg = new RegExp("^#{dirPath}/")

  @traverseDir dirPath, (file) ->

    absolutePath = "#{file.dir}/#{file.name}"
    relativePath = absolutePath.replace(reg, '')
    name = relativePath.replace(/\//g, '.')

    dict[name] = require(absolutePath)

  return dict