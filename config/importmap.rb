# Pin npm packages by running ./bin/importmap

pin 'application', preload: true

# Our JS files
pin 'support'
pin 'popper', to: 'popper.js'
pin 'bootstrap', to: 'bootstrap.min.js'

pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
