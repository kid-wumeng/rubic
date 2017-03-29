###
  @example
  'user.@findAll' => 'user.findAll'
###

module.exports = (name) ->

  index = name.lastIndexOf('.')

  letters = name.split('')
  letters.splice(index+1, 1)
  name = letters.join('')

  return name