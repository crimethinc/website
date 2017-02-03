require "rails_helper"

RSpec.describe "Rack::Redirect", type: :request do
  it "redirects according to redirects.txt" do
    get "/about/faq.html"

    expect(response).to redirect_to("/faq")
  end

  it "redirects with query string" do
    get "/about/faq.html?test=true"

    expect(response).to redirect_to("/faq?test=true")
  end

  it "doesn't redirect when not found" do
    get "/videos"

    expect(response.status).to eq(200)
  end
end
