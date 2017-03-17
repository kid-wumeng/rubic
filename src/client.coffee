$host = null
$onFailure = null



core = {}



core.host = (host) ->
  if host[host.length-1] isnt '/'
    host += '/'
  $host = host



core.onFailure = (onFailure) ->
  $onFailure = onFailure



core.splitData = (data) ->
  jsonDict = {}
  dateDict = {}
  fileDict = {}
  cursor = []

  traversal = (node) ->
    type = typeof(node)
    if type is 'boolean' or type is 'number' or type is 'string'
      jsonDict[cursor.join('.')] = node
    else if node instanceof Date
      dateDict[cursor.join('.')] = node
    else if node instanceof File
      fileDict[cursor.join('.')] = node
    else
      for name of node
        cursor.push(name)
        traversal(node[name])
    cursor.pop()

  traversal(data)
  return { jsonDict, dateDict, fileDict }



core.createFormData = (data) ->
  formData = new FormData()
  data = core.splitData(data)
  core.appendJSON(formData, data.jsonDict)
  core.appendDate(formData, data.dateDict)
  core.appendFile(formData, data.fileDict)
  return formData



core.appendJSON = (formData, jsonDict) ->
  formData.append('$jsonDict', JSON.stringify(jsonDict))



core.appendDate = (formData, dateDict) ->
  for key of dateDict
    dateDict[key] = dateDict[key].getTime()
  formData.append('$dateDict', JSON.stringify(dateDict))



core.appendFile = (formData, fileDict) ->
  for key of fileDict
    formData.append(key, fileDict[key])



core.setHeader = (xhr, ioName) ->
  xhr.setRequestHeader('rubic-io', ioName)
  token = localStorage.getItem('rubic-token')
  if token
    xhr.setRequestHeader('rubic-token', token)



core.call = (ioName, data={}) ->
  if typeof(ioName) isnt 'string'
    throw "io's name should be a string"
  formData = core.createFormData(data)
  xhr = new XMLHttpRequest()
  xhr.open('POST', $host, true)
  core.setHeader(xhr, ioName)
  xhr.send(formData)
  return new Promise (resolve, reject) ->
    xhr.onreadystatechange = core.onReadyStateChange.bind({xhr, resolve, reject})



core.onReadyStateChange = ->
  if @xhr.readyState is XMLHttpRequest.DONE
    if @xhr.status is 200 or @xhr.status is 204
      core.handleSuccess(@xhr, @resolve)
    else
      core.handleFailure(@xhr, @reject)



core.handleSuccess = (xhr, resolve) ->
  token = xhr.getResponseHeader('rubic-token')
  if token
    localStorage.setItem('rubic-token', token)
  {$jsonDict, $dateDict} = JSON.parse(xhr.responseText)
  data = {}
  for key of $jsonDict
    value = $jsonDict[key]
    core.set(data, key, value)
  for key of $dateDict
    value = $dateDict[key]
    value = new Date(value)
    core.set(data, key, value)
  resolve(data)



core.handleFailure = (xhr, reject) ->
  if xhr.getResponseHeader('rubic-token-invalid')
    localStorage.removeItem('rubic-token')
  error = JSON.parse(xhr.responseText)
  if $onFailure
    $onFailure(error)
  else
    reject(error)



core.set = (data, key, value) ->
  names = key.split('.')
  last = names.pop()
  for name, i in names
    if data[name] is undefined
      next = names[i+1]
      if /^\d+$/.test(next)
        data[name] = []
      else
        data[name] = {}
    data = data[name]
  data[last] = value



if typeof(module isnt undefined)
  global.rubic = core
else
  window.rubic = core