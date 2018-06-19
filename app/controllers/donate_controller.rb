class DonateController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'donate'
    @title   = 'Invest Your Money in CrimethInc.'

    redirect_to [:root] unless staging? || Rails.env.development?
  end
end
