'use babel';

import DotinstallNavigationView from './dotinstall-navigation-view';
const shell = require('shell');

export default class DotinstallPaneView {
  constructor(serializedState) {
    this.HANDLE_WIDTH = 8;
    this.DEFAULT_PANE_WIDTH = 640;
    this.USER_AGENT = 'DotinstallAtomPane/1.0.3';

    this.resizing = false;
    this.paneWidth = 640;
    this.element  = document.createElement('div');
    this.webview  = document.createElement('webview');

    this.webview.setAttribute('useragent', window.navigator.userAgent + ' ' + this.USER_AGENT)

    //this.webview.addEventListener('dom-ready', () => {
    //  this.webview.openDevTools();
    //});

    this.webview.addEventListener('new-window', e => {
      if (/^https?:\/\/dotinstall\.com\/(?!help\/415$)/.test(e.url)) {
        this.webview.src = e.url;
      } else {
        shell.openExternal(e.url);
      }
    });

    this.webview.addEventListener('did-start-loading', () => {
      this.startLoading();
    });

    this.webview.addEventListener('did-stop-loading', () => {
      this.navigation.setCanGoBack(this.webview.canGoBack());
      this.navigation.setCanGoForward(this.webview.canGoForward());
      this.stopLoading();
    });

    this.element.classList.add('dotinstall-pane');

    const mainEl = document.createElement('div');
    mainEl.id = 'dotinstall_pane_main';

    this.element.appendChild(mainEl);

    const helpEl = document.createElement('div');
    helpEl.id = 'dotinstall_pane_help';

    const helpBodyEl = document.createElement('div');
    helpBodyEl.classList.add('help-body');
    helpBodyEl.innerHTML = this.helpHtml();

    helpEl.addEventListener('click', () => {
      helpEl.classList.remove('fade');
    });

    helpEl.appendChild(helpBodyEl);

    this.element.appendChild(helpEl);

    this.navigation = new DotinstallNavigationView(this.webview, helpEl);

    mainEl.appendChild(this.navigation.getElement());

    const url = 'http://dotinstall.com';

    this.webview.id = 'dotinstall_view';
    this.webview.classList.add('native-key-bindings');
    this.webview.src = url;

    mainEl.appendChild(this.webview);

    this.loadingBarEl = document.createElement('div');
    this.loadingBarEl.id = 'dotinstall_loading_bar';

    mainEl.appendChild(this.loadingBarEl);
  }

  getTitle() {
    // Used by Atom for tab text
    return 'Dotinstall Pane';
  }

  getDefaultLocation() {
    // This location will be used if the user hasn't overridden it by dragging the item elsewhere.
    // Valid values are "left", "right", "bottom", and "center" (the default).
    return 'left';
  }

  getAllowedLocations() {
    // The locations into which the item can be moved.
    return ['left', 'right'];
  }

  getURI() {
    // Used by Atom to identify the view when toggling.
    return 'atom://dotinstall-pane'
  }

  serialize() {
    return {
      deserializer: 'dotinstall-pane/DotinstallPaneView'
    };
    /*return {
      src: this.webview.src
      //pane_width: this,paneWidth
    };*/
  }

  destroy() {
    this.element.remove();
  }

  getElement() {
    return this.element;
  }

  reload() {
    this.webview.reload();
  }

  startLoading() {
    this.navigation.startLoading();
  }

  stopLoading() {
    this.navigation.stopLoading();
  }

  helpHtml() {
    return [
      '<div class="close-help"><i class="fa fa-times fa-2x"></i></div>',
      '<dl>',
      '<dt>Open/Close</dt>',
      '<dd>Alt (Option) + Shift + D</dd>',
      '<dt>Play/Pause</dt>',
      '<dd>Alt (Option) + Shift + Enter</dd>',
      '<dt>Rewind 5 sec (5秒戻る)</dt>',
      '<dd>Alt (Option) + Shift + [</dd>',
      '<dt>Forword 5 sec (5秒進む)</dt>',
      '<dd>Alt (Option) + Shift + ]</dd>',
      '</dl>',
      '<p class="more-info">',
      '<a href="https://atom.io/packages/dotinstall-pane" target="_blank">https://atom.io/packages/dotinstall-pane</a>',
      '</p>'
    ].join('');
  }
}

