_ = require('lodash')
Schema = require('../Schema')


module.exports = (opt, model) ->

  fields = opt.fields ? {}


  ###
    @example 'name age' => {name: 1, age: 1}
    @example '-name -age' => {name: 0, age: 0}
  ###

  if _.isString(fields)

    string = fields
    array = string.split(/\s+/)
    dict = {}

    for field in array
      if field[0] is '-'
        field = field.slice(1)
        dict[field] = 0
      else
        dict[field] = 1

    fields = dict



  mode = 'none'

  for name, mode of fields
    if mode is 1
      mode = 'pick'
    else
      mode = 'omit'
    break

  if mode is 'pick'
    fields['id'] = 1

  if mode is 'none' or mode is 'omit'

    {schema} = model

    Schema.forRule schema, (rule) ->

      if rule.private
        {keyAbs} = rule
        fields[keyAbs] = 0



  opt.fields = fields