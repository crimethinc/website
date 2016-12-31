class AboutController < ApplicationController
  def start
    @html_id = "page"
    @body_id = "start"
  end

  def read
    @html_id = "page"
    @body_id = "read"
  end

  def watch
    @html_id = "page"
    @body_id = "watch"
  end

  def listen
    @html_id = "page"
    @body_id = "listen"
  end
end
