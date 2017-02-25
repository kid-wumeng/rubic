co = require('co')
Runtime = require('./src/Runtime')
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
    salary:
      $type: Number
  }

  baseSchemaDict =
    Subject: Subject
    Author: Author
    Job: Job
    Comic: Comic
    Thing: Thing


  newDict = SchemaSplicer.spliceDict(baseSchemaDict)
  console.log newDict

).catch((e)->
  console.log e
)