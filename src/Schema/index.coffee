module.exports =

  # public-props
  dict: null

  # public-methods
  filter: require('./@filter')
  forRule: require('./@forRule')
  init: require('./@init')
  computeKey: require('./@computeKey')
  reference: require('./@reference')

  # private-methods
  defaultProps: require('./defaultProps')
  isRuleNode: require('./isRuleNode')