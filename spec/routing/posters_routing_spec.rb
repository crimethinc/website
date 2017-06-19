require "rails_helper"

RSpec.describe PostersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/posters").to route_to("posters#index")
    end

    it "routes to #new" do
      expect(:get => "/posters/new").to route_to("posters#new")
    end

    it "routes to #show" do
      expect(:get => "/posters/1").to route_to("posters#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/posters/1/edit").to route_to("posters#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/posters").to route_to("posters#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/posters/1").to route_to("posters#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/posters/1").to route_to("posters#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/posters/1").to route_to("posters#destroy", :id => "1")
    end

  end
end
