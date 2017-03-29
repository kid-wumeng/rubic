module.exports = (defineDict) ->


  dict = {}


  for name, define of defineDict


    if @isPublic(name)
      name = @formatName(name)
      define.isPublic = true
    else
      define.isPublic = false


    define.name = name
    @formatSchemaIn(define)


    io = @wrap(define)
    io.define = define


    dict[name] = io


  return dict