module.exports = (defineDict) ->


  dict = {}


  for name, define of defineDict


    if @isPublic(name)
      name = @formatName(name)
      define.isPublic = true
    else
      define.isPublic = false


    define.name = name


    define.iSchema = @formatSchema(define.iSchema)


    io = @wrap(define)
    io.define = define


    dict[name] = io


  return dict