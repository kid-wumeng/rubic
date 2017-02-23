module.exports = {

  inSchema:
    mark:
      rate:
        story:
          $ref: 'mark.rate.story'
          $require: true
        image:
          $ref: 'mark.rate.image'
          $require: true
        music:
          $ref: 'mark.rate.music'
          $require: true
    isSimple:
      $type: Boolean
      $default: false

  dep: ['findKID']

  io: ->
    @data.mark.rate
    return yield @io.findPeople()
}