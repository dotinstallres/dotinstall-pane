window.$ = window.jQuery = require('../node_modules/jquery')

module.exports =
class DotinstallNavigationView
  constructor: (webview) ->
    @webview = webview

    @element = $('<div>').addClass('dotinstall-navigation')
    @backButton = @createBackButton()
    @forwardButton = @createForwardButton()
    @reloadButton = @createReloadButton()

    @element
      .append(@backButton)
      .append(@forwardButton)
      .append(@reloadButton)

  createBackButton: ->
    @createButton()
      .append('<i class="fa fa-chevron-left">')
      .on 'click', =>
        @goBack()

  createForwardButton: ->
    @createButton()
      .append('<i class="fa fa-chevron-right">')
      .on 'click', =>
        @goForward()

  createReloadButton: ->
    @createButton()
      .append('<i class="fa fa-refresh">')
      .on 'click', =>
        @reload()

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

  startLoading: =>
    @reloadButton.find('i').addClass('fa-spin')

  stopLoading: =>
    @reloadButton.find('i').removeClass('fa-spin')
