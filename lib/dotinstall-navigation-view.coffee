window.$ = window.jQuery = require('../node_modules/jquery')

module.exports =
class DotinstallNavigationView
  constructor: (webview, help) ->
    @webview = webview
    @help    = help

    @element = $('<div>').addClass('dotinstall-navigation')

    @backButton    = @createBackButton()
    @forwardButton = @createForwardButton()
    @reloadButton  = @createReloadButton()
    @helpButton    = @createHelpButton()

    @element
      .append(@backButton)
      .append(@forwardButton)
      .append(@reloadButton)
      .append(@helpButton)

  createBackButton: ->
    @createButton()
      .addClass('disabled')
      .append('<i class="fa fa-chevron-left">')
      .on 'click', =>
        @goBack()

  createForwardButton: ->
    @createButton()
      .addClass('disabled')
      .append('<i class="fa fa-chevron-right">')
      .on 'click', =>
        @goForward()

  createReloadButton: ->
    @createButton()
      .append('<i class="fa fa-refresh">')
      .on 'click', =>
        @reload()

  createHelpButton: ->
    @createButton()
      .addClass('pull-right')
      .addClass('help-button')
      .append('<i class="fa fa-question fa-lg">')
      .on 'click', =>
        @openHelp()

  createButton: ->
    $('<button>')
      .addClass 'dotinstall-navigation-back'
      .on 'mousedown', ->
        $(this).addClass('pushed')
      .on 'mouseup', ->
        $(this).removeClass('pushed')
      .on 'mouseleave', ->
        $(this).removeClass('pushed')

  getElement: ->
    @element

  goBack: ->
    @webview.executeJavaScript 'history.back()'

  goForward: ->
    @webview.executeJavaScript 'history.forward()'

  reload: ->
    @webview.executeJavaScript 'location.reload()'

  openHelp: =>
    @help.fadeIn()

  startLoading: =>
    @reloadButton.find('i').addClass('fa-spin')

  stopLoading: =>
    @reloadButton.find('i').removeClass('fa-spin')

  setCanGoBack: (can) ->
    if can
      @backButton.removeClass('disabled')
    else
      @backButton.addClass('disabled')

  setCanGoForward: (can) ->
    if can
      @forwardButton.removeClass('disabled')
    else
      @forwardButton.addClass('disabled')
