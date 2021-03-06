Helper = require('../Helper')
Schema = require('../Schema')


module.exports = (cfg) ->

  await @connect(cfg)

  @dict = Helper.requireDir(cfg.dir.model)

  for name, model of @dict
    model.schema ?= {}
    model.schema = Schema.reference(model.schema)
    Schema.computeKey(model.schema)
    Schema.formatRule(model.schema)
    await @ensureIDStore(model)
    await @ensureIndex(model)
    @wrap(model)