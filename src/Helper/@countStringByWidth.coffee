module.exports = (string) ->
  count = 0
  for char, i in string
    code = string.charCodeAt(i)
    count += if code <= 255 then 1 else 2
  return count