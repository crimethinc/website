# Check for existing rbenv, otherwise install ruby-install and chruby
brew 'ruby-install' unless system 'command -v rbenv > /dev/null 2>&1'
brew 'chruby'       unless system 'command -v rbenv > /dev/null 2>&1'

# Check for existing ruby-install, otherwise install rbenv
brew 'rbenv' unless system 'command -v ruby-install > /dev/null 2>&1'

# PaaS CLI
tap 'heroku/brew'
brew 'heroku'

# Active Storage PDF previews
cask 'xquartz'
brew 'mupdf'
brew 'poppler'

# Word DOCX uploads on Article form
brew 'pandoc'

# Database
brew 'postgresql@15'

# Overcommit hooks
brew 'yamllint'

# System tests
cask 'chromedriver'

# Entity relationship diagram (ERD)
brew 'graphviz'
