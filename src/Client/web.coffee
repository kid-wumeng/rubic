$host = null
$catch = null


exports.host = (host) ->
    len = host.length
    last = host[len-1]
    if last isnt '/'
      host += '/'
    $host = host


exports.catch = (catchFn) ->
    $catch = catchFn


exports.fromDataURL = (dataUrl) ->
    base64 = dataUrl.replace(/data:.*;base64,/, '')
    base64Wrapped = "\/Base64(#{base64})\/"
    return base64Wrapped


exports.call = (name, data={}) ->

    forData data, (value, key, parent) ->
      # 编码日期
      if value instanceof Date
        date = value
        timeStamp = date.getTime()
        parent[key] = "\/Date(#{timeStamp})\/"

    url = "#{$host}#{name}"
    data = JSON.stringify(data)

    xhr = new XMLHttpRequest()
    xhr.open('POST', url, true)

    xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8')

    token = localStorage.getItem('Rubic-Token')
    if token
      xhr.setRequestHeader('Rubic-Token', token)

    xhr.send(data)

    return new Promise (resolve, reject) ->

      xhr.onreadystatechange = () ->
        if xhr.readyState is XMLHttpRequest.DONE

          token = xhr.getResponseHeader('Rubic-Token')
          if token
            localStorage.setItem('Rubic-Token', token)

          if xhr.status is 204
            resolve()

          if xhr.status is 200
            data = JSON.parse(xhr.responseText)

            # 解码日期
            forData data, (value, key, parent) ->
              if /^\/Date\(\d+\)\/$/.test(value)
                value = value.slice(6, value.length-2)
                timeStamp = parseInt(value)
                parent[key] = new Date(timeStamp)

            resolve(data)

          if xhr.status >= 400
            error = JSON.parse(xhr.responseText)
            reject(error)
            if $catch
               $catch(error)



forData = (tree, callback) ->

  forEach = (node, key, parent) ->

    type = typeof(node)

    if type is 'boolean' or type is 'number' or type is 'string' or node instanceof Date
      callback(node, key, parent)

    else if Array.isArray(node)
      for child, i in node
        forEach(child, i, node)

    else if typeof(node) is 'object'
      for childKey, child of node
        forEach(child, childKey, node)

  forEach(tree, null, null)