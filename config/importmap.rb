# Pin npm packages by running ./bin/importmap

pin 'application', preload: false

# Our JS files
pin 'support', preload: false
pin 'bootstrap', to: 'bootstrap.min.js', preload: false

# Hotwired JS https://hotwired.dev
pin '@hotwired/stimulus',         to: 'stimulus.min.js', preload: false
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: false

pin_all_from 'app/javascript/controllers', under: 'controllers', preload: false
