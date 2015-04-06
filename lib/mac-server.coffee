macServerView = null
macServerStatusView = null
commandSubscription = null
eventSubscription = null

module.exports =
  activate: (state) ->
    unless macServerView?
      MacServerView = require './mac-server-view'
      macServerView = new MacServerView()
      eventSubscription = macServerView.onServerStatusChange (serverStatus) ->
        macServerStatusView.update(serverStatus)

    commandSubscription = atom.commands.add 'atom-workspace', 'mac-server:toggle', toggle

  consumeStatusBar: (statusBar) ->
    MacServerStatusView = require './mac-server-status-view'
    macServerStatusView = new MacServerStatusView()
    macServerStatusView.initialize(statusBar)
    macServerStatusView.attach()

  deactivate: ->
    commandSubscription?.dispose()
    commandSubscription = null

    eventSubscription?.dispose()
    eventSubscription = null

    macServerStatusView?.destroy()
    macServerStatusView = null

    macServerView?.destroy()
    macServerView = null

toggle = ->
  macServerView.server()
