require "rails_helper"

RSpec.describe MiscController, type: :controller do
  # get "manifest.json",  to: "misc#mainfest_json"
  # get "opensearch.xml", to: "misc#opensearch_xml"
  describe "GET #manifest_json" do
    it "responds successfully" do
      get :manifest_json

      expect(response).to be_successful
    end
  end

  describe "GET #opensearch_xml" do
    it "responds successfully" do
      get :opensearch_xml

      expect(response).to be_successful
    end
  end
end
