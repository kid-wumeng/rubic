Helper = require('../Helper')


module.exports = (cfg) ->

  @dict = Helper.requireDir(cfg.dir.schema)

  for name, schema of @dict
    @addDefaultField(schema)

  for name, schema of @dict
    @dict[name] = @reference(schema, @dict)