module.exports = (name) ->
  
  index = name.lastIndexOf('.')
  return name[index+1] is '@'