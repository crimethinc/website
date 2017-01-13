class HomeController < ApplicationController
  def index
    @body_id = "home"
    @homepage = true

    # feed
    @articles = Article.live.published.limit(8).all.to_a
    # TODO delete this next line, after first week
    @articles = @articles.reject{|a| a.categories.first.name.downcase =~ /calling all anarchists|read all about it/}

    # pinned article
    pinned_to_home_bottom_page_id = setting(:pinned_to_home_bottom_page_id)
    if pinned_to_home_bottom_page_id.present?
      @pinned_to_home_bottom = Page.find(pinned_to_home_bottom_page_id)
    end
  end
end
