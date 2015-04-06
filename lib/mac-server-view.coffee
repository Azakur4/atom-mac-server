{$, View} = require 'space-pen'
{exec} = require 'child_process'
{Emitter} = require 'event-kit'

module.exports =
class MacServerView extends View
  @content: ->
    @div class: 'mac-server', =>
      @label 'Enter your root password'
      @input type: 'password', class: 'mac-server-password native-key-bindings'

  initialize: ->
    @emitter = new Emitter
    @checkServer()

  close: ->
    panelToDestroy = @panel
    @panel = null
    panelToDestroy?.destroy()

  onServerStatusChange: (callback) ->
    @emitter.on 'macserver-status-change', callback

  checkServer: ->
    # Check server status
    cmd = "ps aux | grep '[h]ttpd'"
    exec cmd, (error, stdout, stderr) =>
      if error? and error.code is 1
        @serverStatus = false
      else
        @serverStatus = true

      @emitter.emit 'macserver-status-change', @serverStatus

  dialog: ->
    unless @panel?
      @panel = atom.workspace.addModalPanel item: this

    @panel.show()

    $('.mac-server-password').focus()
    $('.mac-server-password').on 'keydown', (e) =>
      if e.which is 13
        @password = $('.mac-server-password').val()
        $('.mac-server-password').val('')
        @panel.hide()
        @server()
      else if e.which is 27
        $('.mac-server-password').val('')
        @close()

  server: ->
    if @serverStatus
      cmd = 'echo ' + (if @password? then @password else '') + ' | sudo -S apachectl stop'
      exec cmd, (error, stdout, stderr) =>
        if error? and error.code is 1
          @dialog()
        else
          @serverStatus = false
          @emitter.emit 'macserver-status-change', @serverStatus
          @close()
    else
      cmd = 'echo ' + (if @password? then @password else '') + ' | sudo -S apachectl start'
      exec cmd, (error, stdout, stderr) =>
        if error? and error.code is 1
          @dialog()
        else
          @serverStatus = true
          @emitter.emit 'macserver-status-change', @serverStatus
          @close()
