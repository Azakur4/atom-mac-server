{$, View} = require 'atom-space-pen-views'
{Emitter} = require 'event-kit'

module.exports =
class MacServerView extends View
  @content: ->
    @div class: 'mac-server', =>
      @label 'Enter your root password'
      @input type: 'password', class: 'mac-server-password native-key-bindings'

  initialize: ->
    @emitter = new Emitter

    unless @panel?
      @panel = atom.workspace.addModalPanel item: this

    @panel.show()

    $('.mac-server-password').focus()
    $('.mac-server-password').on 'keydown', (e) =>
      if e.which is 13
        password = $('.mac-server-password').val()
        $('.mac-server-password').val('')
        @close()

        @emitter.emit 'macserver-dialog', password
      else if e.which is 27
        $('.mac-server-password').val('')
        @close()

  onServerDialog: (callback) ->
    @emitter.on 'macserver-dialog', callback

  close: ->
    @panel?.destroy()
