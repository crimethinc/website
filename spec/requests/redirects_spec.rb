require "rails_helper"

RSpec.describe "Rack::Redirect", type: :request do
  it "redirects according to redirects.txt" do
    get "http://example.com/about/faq.html"

    expect(response).to redirect_to("/faq")
  end

  it "redirects with query string" do
    get "http://example.com/about/faq.html?test=true"

    expect(response).to redirect_to("/faq?test=true")
  end

  it "doesn't redirect when not found" do
    get "http://example.com/videos"

    expect(response.status).to eq(200)
  end

  it "redirects when the path starts with /blog/" do
    get "http://example.com/blog/2017/01/01/slug"

    expect(response).to redirect_to("/2017/01/01/slug")
  end
end
