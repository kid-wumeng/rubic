Helper = require('../Helper')
Schema = require('../Schema')


module.exports = (cfg) ->

  dict = Helper.requireDir(cfg.dir.io)

  @dict = @formatDict(dict)