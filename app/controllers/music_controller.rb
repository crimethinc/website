class MusicController < ApplicationController
  def index
    redirect_to 'https://crimethinc.bandcamp.com', allow_other_host: true
  end
end
