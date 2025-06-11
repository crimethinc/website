# Pin npm packages by running ./bin/importmap

pin :application

# Our JS files
pin :support

# Stimulus JS (part of Hotwire JS) https://stimulus.hotwired.dev
pin '@hotwired/stimulus',         to: 'stimulus.min.js',     preload: false
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: false

pin_all_from 'app/javascript/controllers', under: 'controllers', preload: false
