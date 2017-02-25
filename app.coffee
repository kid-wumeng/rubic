co = require('co')
Runtime = require('./src/Runtime')
SchemaFormater = require('./src/io/SchemaFormater')
SchemaSplicer = require('./src/io/SchemaSplicer')


co(->

  # Runtime.start()


  Thing = {
    mmm:
      $type: Boolean
  }

  Subject = {
    id:
      $type: Number
    $ref: 'Thing'
  }


  Comic = {
    $ref: 'Subject'
    name:
      $type: String
    author:
      $ref: 'Author'
      job:
        $ref: 'Job'
  }

  Author = {
    name:
      $type: String
    age:
      $type: Number
  }


  Job = {
    $salary: Number
    contents: ['Sktring']
  }

  baseSchemaDict =
    Subject: Subject
    Author: Author
    Job: Job


  nc = SchemaSplicer.splice(Comic, baseSchemaDict)
  console.log nc


).catch((e)->
  console.log e
)