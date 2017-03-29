Helper = require('../Helper')
Schema = require('../Schema')


module.exports = (cfg) ->

  defineDict = Helper.requireDir(cfg.dir.io)
  @dict = @formatDict(defineDict)

  @tokenDict = cfg.token