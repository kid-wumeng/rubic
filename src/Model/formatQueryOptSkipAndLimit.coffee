module.exports = (model, opt) ->

  { page=1, size=0 } = opt

  opt.skip = ( page - 1 ) * size
  opt.limit = size

  delete opt.page
  delete opt.size