module.exports =

  # public-props
  dict: null
  db: null

  # public-methods
  init: require('./@init')

  # private-methods
  connect: require('./connect')
  defaultProps: require('./defaultProps')
  ensureIDStore: require('./ensureIDStore')
  ensureIndex: require('./ensureIndex')
  findOne: require('./findOne')
  formatQuery: require('./formatQuery')
  formatQueryOpt: require('./formatQueryOpt')
  formatQueryOptFields: require('./formatQueryOptFields')
  formatQueryOptSkipAndLimit: require('./formatQueryOptSkipAndLimit')
  wrap: require('./wrap')