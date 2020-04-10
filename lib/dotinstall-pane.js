'use babel';

import DotinstallPaneView from './dotinstall-pane-view';
import {CompositeDisposable, Disposable} from 'atom';

export default {
  DOMAIN: 'dotinstall.com',
  dotinstallPaneView: null,
  subscriptions: null,

  activate(state) {
    this.dotinstallPaneView = new DotinstallPaneView(state.dotinstallPaneViewState);

    this.subscriptions = new CompositeDisposable(
      // Add an opener for our view.
      atom.workspace.addOpener(uri => {
        if (uri === 'atom://dotinstall-pane') {
          return new DotinstallPaneView();
        }
      }),

      // Register command that toggles this view
      atom.commands.add('atom-workspace', {
        'dotinstall-pane:toggle': () => this.toggle(),
        'dotinstall-pane:reload': () => this.reload(),
        'dotinstall-pane:search': () => this.search(),
        'dotinstall-pane:play': () => this.play(),
        'dotinstall-pane:forwardTo': () => this.forwardTo(),
        'dotinstall-pane:rewindTo': () => this.rewindTo()
      }),

      // Destroy any DotinstallPaneView when the package is deactivated.
      new Disposable(() => {
        atom.workspace.getPaneItems().forEach(item => {
          if (item instanceof DotinstallPaneView) {
            item.destroy();
          }
        });
      })
    );
  },

  deactivate() {
    this.subscriptions.dispose();
    this.dotinstallPaneView.destroy();
  },

  /*serialize() {
    return {
      dotinstallPaneViewState: this.dotinstallPaneView.serialize()
    };
  },*/

  toggle() {
    atom.workspace.toggle('atom://dotinstall-pane');
  },

  deserializeDotinstallPaneView(serialized) {
    return new DotinstallPaneView(serialized);
  },

  reload() {
    this.dotinstallPaneView.reload();
  },

  search() {
    const editor = atom.workspace.getActiveTextEditor();

    if (typeof editor === 'undefined') {
      return;
    }

    /*if (editor.getSelectedText().length > 0) {
      const q = encodeURIComponent(editor.getSelectedText());
      const url = `http://${this.DOMAIN}/search?q=${q}`;
      this.dotinstallPaneView.webview.src = url;
    }*/
  },

  play() {
    document.getElementById('dotinstall_view').executeJavaScript('Dotinstall.videoController.playOrPause()');
  },

  forwardTo() {
    document.getElementById('dotinstall_view').executeJavaScript('Dotinstall.videoController.forwardTo(5)');
  },

  rewindTo() {
    document.getElementById('dotinstall_view').executeJavaScript('Dotinstall.videoController.rewindTo(5)');
  }
}

