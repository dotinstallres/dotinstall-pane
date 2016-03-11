window.$ = window.jQuery = require('../node_modules/jquery')
shell = require('shell')

DotinstallNavigationView = require './dotinstall-navigation-view.coffee'

module.exports =
class DotinstallPaneView
  @HANDLE_WIDTH       = 8
  @DEFAULT_PANE_WIDTH = 640
  @USER_AGENT         = 'DotinstallAtomPane/1.0'

  constructor: (serializedState) ->
    @resizing = false
    @element  = document.createElement('div')
    @webview  = document.createElement('webview')

    @webview.setAttribute('useragent', DotinstallPaneView.USER_AGENT)

    @webview.addEventListener 'new-window', (e) =>
      if /^https?:\/\/dotinstall\.com\//.test e.url
        @webview.src = e.url
      else
        shell.openExternal(e.url)

    @webview.addEventListener 'did-start-loading', =>
      @startLoading()

    @webview.addEventListener 'did-stop-loading', =>
      @stopLoading()

    $element = $(@element).addClass('dotinstall-pane')

    $main = $('<div>')
      .attr('id', 'dotinstall_pane_main')
      .appendTo($element)

    @navigation = new DotinstallNavigationView(@webview)

    $main.append(@navigation.getElement())

    if serializedState? and serializedState.pane_width?
      @paneWidth = serializedState.pane_width
    else
      @paneWidth = DotinstallPaneView.DEFAULT_PANE_WIDTH

    $('.dotinstall-pane').width(@paneWidth)

    $main.width(@paneWidth - DotinstallPaneView.HANDLE_WIDTH)

    url = 'http://dotinstall.com'

    if serializedState? and serializedState.src?
      url = serializedState.src

    $(@webview)
      .attr('id', 'dotinstall_view')
      .addClass('native-key-bindings')
      .attr('src', url)
      .appendTo($main)

    $resizeHandle = $('<div>')
      .attr('id', 'dotinstall_resize_handle')
      .on('mousedown', @resizeDotinstallStarted)
      .appendTo($element)

    @loadingBar = $('<div>')
      .attr('id', 'dotinstall_loading_bar')
      .appendTo($main)

    $(document).on('mousemove', @resizeDotinstallPane)
    $(document).on('mouseup', @resizeDotinstallStopped)

  # Returns an object that can be retrieved when package is activated
  serialize: ->
    {
      src: @webview.src
      pane_width: @paneWidth
    }

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  reload: ->
    @webview.reload()

  resizeDotinstallStarted: =>
    @resizing = true

  resizeDotinstallPane: ({pageX, which}) =>
    return unless @resizing and which is 1

    paneWidth = pageX

    if paneWidth < 510
      paneWidth = 510

    $('.dotinstall-pane').width(paneWidth)
    $('#dotinstall_pane_main').width(paneWidth - DotinstallPaneView.HANDLE_WIDTH)

    @paneWidth = paneWidth

  resizeDotinstallStopped: =>
    return unless @resizing

    @resizing = false

  startLoading: =>
    @navigation.startLoading()
    width = 40 + Math.floor Math.random() * 20
    @loadingBar.show().animate width: "#{width}%", 550

  stopLoading: =>
    @navigation.stopLoading()
    @loadingBar.animate width: '100%', 180, =>
      @loadingBar.hide().width(0)
