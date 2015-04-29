macServerStatusView = null

module.exports =
  activate: (state) ->

  consumeStatusBar: (statusBar) ->
    MacServerStatusView = require './mac-server-status-view'
    macServerStatusView = new MacServerStatusView()
    macServerStatusView.initialize(statusBar)
    macServerStatusView.attach()

  deactivate: ->
    macServerStatusView?.destroy()
    macServerStatusView = null
