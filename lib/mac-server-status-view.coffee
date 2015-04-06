class MacServerStatusView extends HTMLDivElement
  initialize: (@statusBar) ->
    @classList.add('macserver-status', 'inline-block')

    # Create message element
    @message = document.createElement('span')
    @message.classList.add('inline-block')
    @message.textContent = "Mac server"
    @appendChild(@message)

  attach: ->
    @tile = @statusBar.addRightTile(priority: 12, item: this)

  destroy: ->
    @tile?.destroy()

  update: (serverStatus) ->
    if serverStatus
      @attach()
    else
      @destroy()

module.exports = document.registerElement('mac-server-status', prototype: MacServerStatusView.prototype)
