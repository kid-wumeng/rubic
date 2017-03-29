Rule = require('../Rule')


module.exports = (schema) ->
  @forRule(schema, Rule.formatRule)