DotinstallPaneView = require './dotinstall-pane-view'
{CompositeDisposable} = require 'atom'

module.exports = DotinstallPane =
  dotinstallPaneView: null
  leftPanel: null
  subscriptions: null
  DOMAIN: 'dotinstall.com'

  activate: (state) ->
    @dotinstallPaneView = new DotinstallPaneView(state.dotinstallPaneViewState)
    @leftPanel = atom.workspace.addLeftPanel(
        item: @dotinstallPaneView.getElement(),
        visible: false,
        priority: 0
    )

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', {
      'dotinstall-pane:toggle': => @toggle()
      'dotinstall-pane:reload': => @reload()
      'dotinstall-pane:search': => @search()
      'dotinstall-pane:play': => @play()
    }

  deactivate: ->
    @leftPanel.destroy()
    @subscriptions.dispose()
    @dotinstallPaneView.destroy()

  serialize: ->
    dotinstallPaneViewState: @dotinstallPaneView.serialize()

  toggle: ->
    if @leftPanel.isVisible()
      @leftPanel.hide()
    else
      @leftPanel.show()

  reload: ->
    @dotinstallPaneView.reload()

  search: ->
    e = atom.workspace.getActiveTextEditor()

    return unless e?

    if e.getSelectedText().length > 0
      q = encodeURIComponent(e.getSelectedText())
      url = "http://#{@DOMAIN}/search?q=#{q}"
      @leftPanel.show() unless @leftPanel.isVisible()
      @dotinstallPaneView.webview.src = url

  play: ->
    @dotinstallPaneView.webview.executeJavaScript 'Dotinstall.videoController.playOrPause()'
