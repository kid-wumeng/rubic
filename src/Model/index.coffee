module.exports =

  # public-props
  dict: null
  db: null

  # public-methods
  init: require('./@init')

  # private-methods
  connect: require('./connect')
  ensureIDStore: require('./ensureIDStore')
  ensureIndex: require('./ensureIndex')
  find: require('./find')
  findJoin: require('./findJoin')
  findOne: require('./findOne')
  findOneJoin: require('./findOneJoin')
  formatQuery: require('./formatQuery')
  formatQueryOpt: require('./formatQueryOpt')
  formatQueryOptFields: require('./formatQueryOptFields')
  formatQueryOptSkipAndLimit: require('./formatQueryOptSkipAndLimit')
  wrap: require('./wrap')