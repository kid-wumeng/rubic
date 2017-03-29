module.exports =

  # public-props
  dict: null

  # public-methods
  filter: require('./@filter')
  formatRule: require('./@formatRule')
  forRule: require('./@forRule')
  init: require('./@init')
  computeKey: require('./@computeKey')
  reference: require('./@reference')

  # private-methods
  addDefaultField: require('./addDefaultField')
  isRuleNode: require('./isRuleNode')