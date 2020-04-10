'use babel';

export default class DotinstallNavigationView {
  constructor(webview, help) {
    this.webview = webview;
    this.help    = help;

    this.element = document.createElement('div');
    this.element.classList.add('dotinstall-navigation');

    this.backButton    = this.createBackButton();
    this.forwardButton = this.createForwardButton();
    this.reloadButton  = this.createReloadButton();
    this.homeButton    = this.createHomeButton();
    this.helpButton    = this.createHelpButton();

    this.element.appendChild(this.backButton);
    this.element.appendChild(this.forwardButton);
    this.element.appendChild(this.reloadButton);
    this.element.appendChild(this.homeButton);
    this.element.appendChild(this.helpButton);
  }

  createBackButton() {
    const i = document.createElement('i');
    i.classList.add('fa', 'fa-chevron-left');

    const btn = this.createButton();

    btn.classList.add('disabled');
    btn.addEventListener('click', () => {
      this.goBack();
    });

    btn.appendChild(i);

    return btn;
  }

  createForwardButton() {
    const i = document.createElement('i');
    i.classList.add('fa', 'fa-chevron-right');

    const btn = this.createButton();

    btn.classList.add('disabled');
    btn.addEventListener('click', () => {
      this.goForward();
    });

    btn.appendChild(i);

    return btn;
  }

  createReloadButton() {
    const i = document.createElement('i');
    i.classList.add('fa', 'fa-refresh');

    const btn = this.createButton();

    btn.addEventListener('click', () => {
      this.reload();
    });

    btn.appendChild(i);

    return btn;
  }

  createHomeButton() {
    const i = document.createElement('i');
    i.classList.add('fa', 'fa-home');

    const btn = this.createButton();

    btn.addEventListener('click', () => {
      this.home();
    });

    btn.appendChild(i);

    return btn;
  }

  createHelpButton() {
    const i = document.createElement('i');
    i.classList.add('fa', 'fa-question', 'fa-lg');

    const btn = this.createButton();

    btn.classList.add('pull-right', 'help-button');

    btn.addEventListener('click', () => {
      this.openHelp();
    });

    btn.appendChild(i);

    return btn;
  }

  createButton() {
    const btn = document.createElement('button');

    btn.classList.add('dotinstall-navigation-back');

    btn.addEventListener('mousedown', () => {
      btn.classList.add('pushed');
    });

    btn.addEventListener('mouseup', () => {
      btn.classList.remove('pushed');
    });

    btn.addEventListener('mouseleave', () => {
      btn.classList.remove('pushed');
    });

    return btn;
  }

  destroy() {
    this.element.remove();
  }

  getElement() {
    return this.element;
  }

  goBack() {
    this.webview.executeJavaScript('history.back()');
  }

  goForward() {
    this.webview.executeJavaScript('history.forward()');
  }

  reload() {
    this.webview.executeJavaScript('location.reload()');
  }

  home() {
    this.webview.src = 'https://dotinstall.com';
  }

  openHelp() {
    this.help.classList.add('fade');
  }

  startLoading() {
    this.reloadButton.querySelector('i').classList.add('fa-spin');
  }

  stopLoading() {
    this.reloadButton.querySelector('i').classList.remove('fa-spin');
  }

  setCanGoBack(can) {
    if (can) {
      this.backButton.classList.remove('disabled');
    } else {
      this.backButton.classList.add('disabled');
    }
  }

  setCanGoForward(can) {
    if (can) {
      this.forwardButton.classList.remove('disabled');
    } else {
      this.forwardButton.classList.add('disabled');
    }
  }
}

