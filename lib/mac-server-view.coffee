{View} = require 'atom-space-pen-views'
{Emitter} = require 'event-kit'

module.exports =
class MacServerView extends View
  @content: ->
    @div class: 'mac-server', =>
      @label 'Enter your root password'
      @input type: 'password', class: 'mac-server-password native-key-bindings', outlet: 'prompt'

  initialize: ->
    @emitter = new Emitter

    unless @panel?
      @panel = atom.workspace.addModalPanel item: this

    @panel.show()

    @prompt.on 'keydown', (e) =>
      if e.which is 13
        password = @prompt.val()
        @prompt.val('')
        @close()

        @emitter.emit 'macserver-dialog', password
      else if e.which is 27
        @prompt.val('')
        @close()

    @prompt.focus()

  onServerDialog: (callback) ->
    @emitter.on 'macserver-dialog', callback

  close: ->
    @panel?.destroy()
