class HomeController < ApplicationController
  def index
    @body_id = "home"
    @homepage = true

    # feed
    @articles = Article.live.published.limit(7).all.to_a

    # pinned article
    pinned_to_home_bottom_page_id = setting(:pinned_to_home_bottom_page_id)
    if pinned_to_home_bottom_page_id.present?
      @pinned_to_home_bottom = Page.find(pinned_to_home_bottom_page_id)
    end
  end
end
