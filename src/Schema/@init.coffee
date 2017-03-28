Helper = require('../Helper')
defaultProps = require('./defaultProps')
reference = require('./reference')


module.exports = (cfg) ->

  dict = Helper.requireDir(cfg.dir.schema)

  for name, schema of dict
    dict[name] = defaultProps(schema)

  for name, schema of dict
    dict[name] = reference(schema, dict)

  return {schemaDict: dict}