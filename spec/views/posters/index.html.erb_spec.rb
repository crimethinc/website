require 'rails_helper'

RSpec.describe "posters/index", type: :view do
  before(:each) do
    assign(:posters, [
      Poster.create!(
        :sticker => false,
        :title => "MyText",
        :subtitle => "MyText",
        :content => "MyText",
        :content_format => "Content Format",
        :buy_info => "MyText",
        :buy_url => "MyText",
        :price_in_cents => 2,
        :summary => "MyText",
        :description => "MyText",
        :front_image_present => false,
        :back_image_present => false,
        :read_download_present => false,
        :print_download_present => false,
        :lite_download_present => false,
        :slug => "MyText",
        :height => "Height",
        :width => "Width"
      ),
      Poster.create!(
        :sticker => false,
        :title => "MyText",
        :subtitle => "MyText",
        :content => "MyText",
        :content_format => "Content Format",
        :buy_info => "MyText",
        :buy_url => "MyText",
        :price_in_cents => 2,
        :summary => "MyText",
        :description => "MyText",
        :front_image_present => false,
        :back_image_present => false,
        :read_download_present => false,
        :print_download_present => false,
        :lite_download_present => false,
        :slug => "MyText",
        :height => "Height",
        :width => "Width"
      )
    ])
  end

  it "renders a list of posters" do
    render
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Content Format".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Height".to_s, :count => 2
    assert_select "tr>td", :text => "Width".to_s, :count => 2
  end
end
