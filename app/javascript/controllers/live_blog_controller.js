import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="live-blog"
export default class extends Controller {
  static targets = [ "container", "text" ]
  static values = {
    // Rails' Time.current.to_i gives unix time in seconds, JS gives
    // it in milliseconds. Here we normalize the JS value to seconds
    pageLoadedAt: { type: Number, default: parseInt(Date.now() / 1000) },
    updateCount: { type: Number, default: 0 },
    url: { type: String, default: '' },
    pollingUrl: { type: String, default: '' },

    // Poll every 1 minute (milliseconds * seconds * minutes)
    refreshInterval: { type: Number, default: (1000 * 60 * 1) }
  }

  initialize() {
    let params = new URLSearchParams();
    params.append("published_since", this.pageLoadedAtValue)
    let url = this.urlValue + "?" + params

    this.pollingUrlValue = url

    if (this.hasRefreshIntervalValue) {
      this.startPolling()
    }
  }

  disconnect() {
    this.stopPolling()
  }

  count(data) {
    if (typeof data != "undefined") {
      this.updateCountValue = data.posts.length
    }
  }

  updateCountValueChanged() {
    if(this.updateCountValue > 0) {
      let postPlural = this.updateCountValue > 1 ? "posts" : "post";
      let text = "Psst! Refresh for " + this.updateCountValue + " new " + postPlural

      this.textTarget.innerText =  text
      this.open()
    }
  }

  open() {
    this.containerTarget.hidden = false
  }

  close() {
    event.preventDefault()
    this.containerTarget.hidden = true
  }

  startPolling() {
    this.refreshTimer = setInterval(() => {
      this.poll()
    }, this.refreshIntervalValue)
  }

  stopPolling() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }

  poll() {
    fetch(this.pollingUrlValue)
      .then(response => response.json())
      .then(json => this.count(json))
  }
}
