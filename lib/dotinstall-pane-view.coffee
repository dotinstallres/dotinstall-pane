window.$ = window.jQuery = require('../node_modules/jquery')
shell = require('shell')

DotinstallNavigationView = require './dotinstall-navigation-view.coffee'

module.exports =
class DotinstallPaneView
  @HANDLE_WIDTH       = 8
  @DEFAULT_PANE_WIDTH = 640
  @USER_AGENT         = 'DotinstallAtomPane/1.0.1'

  constructor: (serializedState) ->
    @resizing = false
    @element  = document.createElement('div')
    @webview  = document.createElement('webview')

    @webview.setAttribute('useragent', DotinstallPaneView.USER_AGENT)

    @webview.addEventListener 'new-window', (e) =>
      if /^https?:\/\/dotinstall\.com\/(?!q\/new)/.test e.url
        @webview.src = e.url
      else
        shell.openExternal(e.url)

    @webview.addEventListener 'did-start-loading', =>
      @startLoading()

    @webview.addEventListener 'did-stop-loading', =>
      @navigation.setCanGoBack @webview.canGoBack()
      @navigation.setCanGoForward @webview.canGoForward()
      @stopLoading()

    $element = $(@element).addClass('dotinstall-pane')

    $main = $('<div>')
      .attr('id', 'dotinstall_pane_main')
      .appendTo($element)

    $help = $('<div>')
      .attr('id', 'dotinstall_pane_help')
      .append(
        $('<div class="help-body">').html(@helpHtml())
      ).on(
        'click', -> $(@).fadeOut()
      ).appendTo($element)

    @navigation = new DotinstallNavigationView(@webview, $help)

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
    $(window).on('resize', @fitHeight)

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

  fitHeight: =>
    $(@webview).height($('.dotinstall-pane').height())

  startLoading: =>
    @navigation.startLoading()
    width = 40 + Math.floor Math.random() * 20
    @loadingBar.show().animate width: "#{width}%", 550

  stopLoading: =>
    @navigation.stopLoading()
    @loadingBar.animate width: '100%', 180, =>
      @loadingBar.hide().width(0)

  helpHtml: ->
    [
      '<div class="close-help"><i class="fa fa-times fa-2x"></i></div>',
      '<dl>',
      '<dt>Open/Close</dt>',
      '<dd>Alt (Option) + Shift + D</dd>',
      '<dt>Play/Pause</dt>',
      '<dd>Alt (Option) + Shift + Enter</dd>',
      '</dl>',
      '<p class="more-info">',
      '<a href="https://atom.io/packages/dotinstall-pane" target="_blank">https://atom.io/packages/dotinstall-pane</a>',
      '</p>'
    ].join('')
