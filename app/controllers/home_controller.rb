class HomeController < ApplicationController
  def index
    @body_id = "home"
    @homepage = true

    # feed
    @articles = Article.includes(:categories, :status).live.published.root.limit(7).all.to_a

    # pinned articles
    # pinned: site top
    pinned_to_site_top_page_id = setting(:pinned_to_site_top_page_id)
    if pinned_to_site_top_page_id.present?
      @pinned_to_site_top = Page.find(pinned_to_site_top_page_id)
    end

    # pinned: home bottom
    pinned_to_home_bottom_page_id = setting(:pinned_to_home_bottom_page_id)
    if pinned_to_home_bottom_page_id.present?
      @pinned_to_home_bottom = Page.find(pinned_to_home_bottom_page_id)
    end
  end
end
