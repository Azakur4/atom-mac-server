MacServerView = require './mac-server-view'
{exec} = require 'child_process'

class MacServerStatusView extends HTMLDivElement
  initialize: (@statusBar) ->
    @classList.add('macserver-status', 'inline-block')

    # Create message element
    @statusLink = document.createElement('a')
    @statusLink.classList.add('inline-block')
    @statusLink.href = '#'
    @statusLink.textContent = "Mac Server"

    @appendChild(@statusLink)

    @serverStatus = null
    @handleEvents()

  attach: ->
    @tile = @statusBar.addRightTile(priority: 12, item: this)

  destroy: ->
    @clickSubscription?.dispose()
    @tile?.destroy()

  handleEvents: ->
    @addEventListener('click', @server)
    @clickSubscription = dispose: => @removeEventListener('click', @server)

  update: () ->
    if @serverStatus
      @statusLink.textContent = "Server Running"
    else
      @statusLink.textContent = "Server Stopped"

  checkServer: ->
    # Check server status
    cmd = "ps aux | grep '[h]ttpd'"
    exec cmd, (error, stdout, stderr) =>
      if error? and error.code is 1
        @serverStatus = false
      else
        @serverStatus = true

      @update()

  dialog: ->
    macServerView = new MacServerView()
    macServerView.onServerDialog (password) =>
        @server password

  server: (password = '') ->
    if @serverStatus == null
      @checkServer()
    else if @serverStatus
      cmd = 'echo ' + (if password? then password else '') + ' | sudo -S apachectl stop'
      exec cmd, (error, stdout, stderr) =>
        if error? and error.code is 1
          @dialog()
        else
          @serverStatus = false
          @update()
    else
      cmd = 'echo ' + (if password? then password else '') + ' | sudo -S apachectl start'
      exec cmd, (error, stdout, stderr) =>
        if error? and error.code is 1
          @dialog()
        else
          @serverStatus = true
          @update()

    atom.views.getView(atom.workspace.getActiveTextEditor())?.focus()

module.exports = document.registerElement('mac-server-status', prototype: MacServerStatusView.prototype)
