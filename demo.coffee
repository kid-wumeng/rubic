rubic = require('./src')
axios = require('axios')
http = require('http')


do ->
  await rubic.init({
    dir:
      schema: "#{__dirname}/schemas"
      model: "#{__dirname}/models"
      io: "#{__dirname}/io"
    tokenSecret: 'i am coding'
    token:
      user: 60
      admin: 10
    database:
      name: 'orz-world'
  })

  FormData = require('form-data')

  form = new FormData()

  $json = {
    '1':
      person:
        name: 'kid'
  }
  $date = {
    '0':
      publishDates: [
        Date.now()
        Date.now()+6789
        Date.now()+10000065
        Date.now()+445
      ]
  }

  form.append('$json', JSON.stringify($json))
  form.append('$date', JSON.stringify($date))
  form.append('0.abc.face', new Buffer(10))

  # request = http.request({
  #   method: 'post',
  #   host: '127.0.0.1',
  #   port: 3000,
  #   path: '/aaa',
  #   headers: form.getHeaders()
  # })

  # form.pipe(request)
