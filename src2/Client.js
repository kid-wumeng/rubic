;(function(){

  var _host = null;
  var _onFailure = null;

  var Core = {};

  Core.host = function(host){
    if(host[host.length-1] !== '/'){
      host += '/';
    }
    _host = host;
  }

  Core.onFailure = function(onFailure){
    _onFailure = onFailure;
  }

  Core.parse = function(data){
    var jsonDict = {};
    var dateDict = {};
    var fileDict = {};
    var cursor = [];
    traversal(data);
    return {
      jsonDict: jsonDict,
      dateDict: dateDict,
      fileDict: fileDict
    };

    function traversal(node){
      var type = typeof(node);
      if(type === 'boolean' || type === 'number' || type === 'string')
        jsonDict[cursor.join('.')] = node;
      else if(node instanceof Date)
        dateDict[cursor.join('.')] = node;
      else if(node instanceof File)
        fileDict[cursor.join('.')] = node;
      else
        for(var name in node){
          cursor.push(name);
          traversal(node[name]);
        }
      cursor.pop();
    }
  }

  Core.createFormData = function(data){
    var formData = new FormData();
    data = Core.parse(data);
    Core.appendJSON(formData, data.jsonDict);
    Core.appendDate(formData, data.dateDict);
    Core.appendFile(formData, data.fileDict);
    return formData
  }

  Core.appendJSON = function(formData, jsonDict){
    formData.append('$jsonDict', JSON.stringify(jsonDict));
  }

  Core.appendDate = function(formData, dateDict){
    for(var key in dateDict){
      dateDict[key] = dateDict[key].getTime();
    }
    formData.append('$dateDict', JSON.stringify(dateDict));
  }

  Core.appendFile = function(formData, fileDict){
    for(var key in fileDict){
      formData.append(key, fileDict[key]);
    }
  }

  Core.setHeader = function(xhr, ioName){
    xhr.setRequestHeader('rubic-io', ioName);
    var token = localStorage.getItem('rubic-token');
    if(token){
      xhr.setRequestHeader('rubic-token', token);
    }
  }

  Core.call = function(io, data){
    if(typeof(io) !== 'string'){
      throw '未设置io';
    }

    data = data || {};
    var formData = Core.createFormData(data);

    var xhr = new XMLHttpRequest();
    xhr.open('POST', _host, true);
    Core.setHeader(xhr, io);
    xhr.send(formData);

    return new Promise(function(resolve, reject){
      xhr.onreadystatechange = Core.onReadyStateChange.bind({
        xhr: xhr,
        resolve: resolve,
        reject: reject
      })
    });
  }

  Core.onReadyStateChange = function(){
    if(this.xhr.readyState === XMLHttpRequest.DONE){
      if(this.xhr.status === 200){
        Core.handleSuccess(this.xhr, this.resolve);
      }else{
        Core.handleFailure(this.xhr, this.reject);
      }
    }
  }

  Core.handleSuccess = function(xhr, resolve){
    var token = xhr.getResponseHeader('rubic-token')
    if(token){
      localStorage.setItem('rubic-token', token);
    }
    var result = JSON.parse(xhr.responseText);
    var data = {};
    var key;
    var value;
    for(key in result.jsonDict){
      value = result.jsonDict[key]
      Core.set(data, key, value)
    }
    for(key in result.dateDict){
      value = result.dateDict[key]
      value = new Date(value)
      Core.set(data, key, value)
    }
    resolve(data);
  }

  Core.handleFailure = function(xhr, reject){
    var tokenExpires = xhr.getResponseHeader('rubic-token-expires');
    if(tokenExpires){
      localStorage.removeItem('rubic-token');
    }
    var error = JSON.parse(xhr.responseText);
    if(_onFailure){
      _onFailure(error);
    }else{
      reject(error);
    }
  }

  Core.set = function(object, key, value){
    var names = key.split('.');
    for(var i = 0; i < names.length-1; i++){
      var name = names[i]
      var nextName = names[i+1]
      if(/^\d+$/.test(nextName)){
        if(!(object[name] instanceof Array)){
          object[name] = []
        }
      }else{
        if(typeof(object[name]) !== 'object'){
          object[name] = {}
        }
      }
      object = object[name]
    }
    var lastName = names[names.length-1]
    object[lastName] = value
  }

  global.rubic = Core;

})();