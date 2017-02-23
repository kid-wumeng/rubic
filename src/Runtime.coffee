IOWrapper = require('./io/IOWrapper')


class Runtime


# temp
aaa = {
  name: 'aaa'
  io: () ->
    return "hello #{@data.name}"
}

bbb = {
  name: 'bbb'
  inSchema:
    a:
      $type: String
    b:
      c:
        $type: Number
        $default: 1
    d: [{
      e:
        f:
          $type: String
        g: [{
          $type: String
        }]
    }]
  io: () ->
    # return @io.aaa({name: @data.name})
}


ioDefines = [aaa, bbb]


Runtime.start = () ->
  core = {}
  core.io = {}
  @readyIO(ioDefines, core)
  core.io.bbb({
    name: 'kid'
    d: [14, {e: 88}]
  })


Runtime.readyIO = (ioDefines, core) ->
  for ioDefine in ioDefines
    core.io[ioDefine.name] = IOWrapper.wrap(ioDefine, core)



module.exports = Runtime