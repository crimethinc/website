require "rails_helper"

RSpec.describe AboutController, type: :controller do
  describe "GET #read" do
    let!(:featured_current_events) { Article.create!(slug: "feature-report-back-from-the-battle-for-sacred-ground") }
    let!(:featured_strategy_and_analysis) { Article.create!(slug: "feature-understanding-the-kurdish-resistance-historical-overview-eyewitness-report") }
    let!(:featured_theory_and_critique) { Article.create!(slug: "feature-from-democracy-to-freedom") }
    let!(:featured_classics) { Article.create!(slug: "why-we-dont-make-demands") }

    it "assigns all instance variables" do
      get :read

      expect(assigns[:featured_current_events]).to eq(featured_current_events)
      expect(assigns[:featured_strategy_and_analysis]).to eq(featured_strategy_and_analysis)
      expect(assigns[:featured_theory_and_critique]).to eq(featured_theory_and_critique)
      expect(assigns[:featured_classics]).to eq(featured_classics)

      expect(assigns[:html_id]).to eq("page")
      expect(assigns[:body_id]).to eq("read")
    end
  end

  describe "GET #post_order_success" do
    it "assigns all instance variables" do
      ordernum = "1"

      get :post_order_success, params: { ordernum: ordernum }

      expect(assigns[:html_id]).to eq("page")
      expect(assigns[:body_id]).to eq("store")
      expect(assigns[:title]).to eq("Post-Order Glow")
      expect(assigns[:order_id]).to eq(ordernum)
    end
  end
end
