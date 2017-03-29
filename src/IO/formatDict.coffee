module.exports = (dict) ->


  dictFormatted = {}


  for name, io of dict

    @formatSchemaIn(io)
    io = @wrap(io)


    if @isPublic(name)
      name = @formatName(name)
      io.isPublic = true
    else
      io.isPublic = false


    dictFormatted[name] = io


  return dictFormatted