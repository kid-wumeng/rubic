Helper = require('../Helper')
Schema = require('../Schema')


module.exports = (cfg, schemaDict) ->

  await @connect(cfg)

  @dict = Helper.requireDir(cfg.dir.model)

  for name, model of @dict
    model.schema = Schema.reference(model.schema)
    Schema.computeKey(model.schema)
    @defaultProps(model.schema)
    await @ensureIDStore(model)
    await @ensureIndex(model)
    @wrap(model)