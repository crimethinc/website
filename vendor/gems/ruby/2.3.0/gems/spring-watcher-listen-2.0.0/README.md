# Listen watcher for Spring

[![Build Status](https://travis-ci.org/jonleighton/spring-watcher-listen.png?branch=master)](https://travis-ci.org/jonleighton/spring-watcher-listen)
[![Gem Version](https://badge.fury.io/rb/spring-watcher-listen.png)](http://badge.fury.io/rb/spring-watcher-listen)

This gem makes [Spring](https://github.com/rails/spring) watch the
filesystem for changes using [Listen](https://github.com/guard/listen)
rather than by polling the filesystem.

Currently only Listen 1 is supported. However there is [an
effort](https://github.com/jonleighton/spring-watcher-listen/issues/1)
to implement Listen 2 support.

## Installation

Stop Spring if it's already running:

    $ spring stop

Add this line to your application's Gemfile:

    gem 'spring-watcher-listen', group: :development

And then execute:

    $ bundle
