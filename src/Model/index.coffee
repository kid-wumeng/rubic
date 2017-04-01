module.exports =

  # public-props
  dict: null
  db: null

  # public-methods
  aggregate: require('./@aggregate')
  count: require('./@count')
  create: require('./@create')
  find: require('./@find')
  findOne: require('./@findOne')
  init: require('./@init')
  remove: require('./@remove')
  update: require('./@update')
  updateMany: require('./@updateMany')

  # private-methods
  connect: require('./connect')
  ensureIDStore: require('./ensureIDStore')
  ensureIndex: require('./ensureIndex')
  findJoin: require('./findJoin')
  findJoinArray: require('./findJoinArray')
  findJoinOne: require('./findJoinOne')
  findOneJoin: require('./findOneJoin')
  findOneJoinArray: require('./findOneJoinArray')
  findOneJoinOne: require('./findOneJoinOne')
  formatModifier: require('./formatModifier')
  formatQuery: require('./formatQuery')
  formatQueryOpt: require('./formatQueryOpt')
  formatQueryOptFields: require('./formatQueryOptFields')
  formatQueryOptSkipAndLimit: require('./formatQueryOptSkipAndLimit')
  makeID: require('./makeID')
  wrap: require('./wrap')