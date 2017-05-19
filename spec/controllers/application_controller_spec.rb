require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    before_action :authorize, only: [:destroy]
    before_action :set_title

    def index
      signed_in?

      render plain: "index"
    end

    def new
      render plain: "new"
    end

    def show
      render plain: "show"
    end

    def edit
      render plain: "edit"
    end

    def destroy
      render plain: "authorized"
    end

    def set_title
      @title = params[:title]
    end
  end

  describe "#page_title" do
    it "adds admin to the title in admin routes" do
      expect(controller).to receive(:controller_path).and_return("admin/articles")

      get :index, params: { title: "title" }

      expect(controller.page_title).to eq("CrimethInc. Admin : title")
    end

    it "appends the set title" do
      get :index, params: { title: "title" }

      expect(controller.page_title).to eq("CrimethInc. : title")
    end

    it "has a default title" do
      get :index

      expect(controller.page_title).to eq("CrimethInc.")
    end
  end

  describe "#set_pinned_pages" do
    context "with all pinned" do
      let(:site_top) { Page.create(title: "Site Top") }
      let(:footer_top) { Page.create(title: "footer top") }
      let(:footer_bottom) { Page.create(title: "footer bottom") }

      before do
        Setting.create!(name: "pinned to site top page id", saved_content: site_top.id)
        Setting.create!(name: "pinned to footer top page id", saved_content: footer_top.id)
        Setting.create!(name: "pinned to footer bottom page id", saved_content: footer_bottom.id)
      end

      it "assigns all pinned pages" do
        get :index

        expect(assigns[:pinned_to_site_top]).to eq(site_top)
        expect(assigns[:pinned_to_footer_top]).to eq(footer_top)
        expect(assigns[:pinned_to_footer_bottom]).to eq(footer_bottom)
      end
    end
  end

  describe "#current_user" do
    let(:user) { User.create(username: "example", password: "x" * 30) }

    it "loads from session" do
      session[:user_id] = user.id

      get :index

      expect(assigns[:current_user]).to eq(user)
    end

    it "doesn't break with no session" do
      get :index

      expect(assigns[:current_user]).to be_nil
    end
  end

  describe "#signed_in?" do
    let(:user) { User.create(username: "example", password: "x" * 30) }

    it "is true with a user" do
      session[:user_id] = user.id

      get :index

      expect(controller.signed_in?).to be_truthy
    end

    it "is false with no user" do
      get :index

      expect(controller.signed_in?).to be_falsey
    end
  end

  describe "#authorize" do
    let(:user) { User.create(username: "example", password: "x" * 30) }

    it "renders with a user" do
      session[:user_id] = user.id

      get :destroy, params: { id: 1 }

      expect(response.status).to eq(200)
    end

    it "is false with no user" do
      get :destroy, params: { id: 1 }

      expect(response.status).to eq(302)
    end
  end

  describe "#listing?" do
    it "is true on index" do
      get :index

      expect(controller.listing?).to be(true)
    end
  end

  describe "#showing?" do
    it "is true on show" do
      get :show, params: { id: 1 }

      expect(controller.showing?).to be(true)
    end
  end

  describe "#editing?" do
    it "is true on edit" do
      get :edit, params: { id: 1 }

      expect(controller.editing?).to be(true)
    end
  end

  describe "#creating?" do
    it "is true on new" do
      get :new

      expect(controller.creating?).to be(true)
    end
  end

  describe "#check_for_redirection" do
    it "redirects temporarily when present" do
      Redirect.create(source_path: "/anonymous", target_path: "http://example.com", temporary: true)

      get :index

      expect(response.status).to eq(302)
    end

    it "redirects permanently when present" do
      Redirect.create(source_path: "/anonymous", target_path: "http://example.com", temporary: false)

      get :index

      expect(response.status).to eq(301)
    end
  end

  describe "#strip_file_extension" do
    it "strips .html" do
      get :index, format: "html"

      expect(response.status).to eq(302)
    end
  end

  describe "#strip_www" do
    it "strips www" do
      request.host = "www.crimethinc.com"

      get :index

      expect(response.status).to eq(302)
    end
  end

  describe "#render_markdown" do
    subject { controller.render_markdown("text").strip }

    it { is_expected.to eq("<p>text</p>") }
  end

  describe "#render_content" do
    let(:post) { Page.new(content: "text", content_format: "markdown") }

    subject { controller.render_content(post).strip }

    it { is_expected.to eq("<p>text</p>") }
  end
end
