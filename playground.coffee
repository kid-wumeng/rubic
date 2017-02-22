_ = require('lodash')
SchemaFactory = require('./src/schema/SchemaFactory')
DataFilter = require('./src/schema/DataFilter')


Thing = {
  $name: 'Thing'
  id:
    $type: Number
}

Subject = {
  $name: 'Subject'
  $from: 'Thing'
}

Comic = {
  $name: 'Comic'
  $from: 'Subject'
  author:
    $from: 'Author'
}

Author = {
  $name: 'Author'
  name:
    $type: String
  age:
    $type: Number
  job:
    $from: 'Job'
}

Job = {
  $name: 'Job'
  name:
    $type: String
    $require: true
    $max: 1
}

arr = []
arr.push(Thing)
arr.push(Subject)
arr.push(Comic)
arr.push(Author)
arr.push(Job)



co = require('co')
Runtime = require('./src/Runtime')
$ = require('./src/Core')

co(->
  yield Runtime.start()

  people = yield $.table('People')
    .page(2).size(2)
    .omit('id')
    .findAll()

  console.log people

).catch((e)->
  console.log e
)