require 'rails_helper'

RSpec.describe "posters/edit", type: :view do
  before(:each) do
    @poster = assign(:poster, Poster.create!(
      :sticker => false,
      :title => "MyText",
      :subtitle => "MyText",
      :content => "MyText",
      :content_format => "MyString",
      :buy_info => "MyText",
      :buy_url => "MyText",
      :price_in_cents => 1,
      :summary => "MyText",
      :description => "MyText",
      :front_image_present => false,
      :back_image_present => false,
      :read_download_present => false,
      :print_download_present => false,
      :lite_download_present => false,
      :slug => "MyText",
      :height => "MyString",
      :width => "MyString"
    ))
  end

  it "renders the edit poster form" do
    render

    assert_select "form[action=?][method=?]", poster_path(@poster), "post" do

      assert_select "input[name=?]", "poster[sticker]"

      assert_select "textarea[name=?]", "poster[title]"

      assert_select "textarea[name=?]", "poster[subtitle]"

      assert_select "textarea[name=?]", "poster[content]"

      assert_select "input[name=?]", "poster[content_format]"

      assert_select "textarea[name=?]", "poster[buy_info]"

      assert_select "textarea[name=?]", "poster[buy_url]"

      assert_select "input[name=?]", "poster[price_in_cents]"

      assert_select "textarea[name=?]", "poster[summary]"

      assert_select "textarea[name=?]", "poster[description]"

      assert_select "input[name=?]", "poster[front_image_present]"

      assert_select "input[name=?]", "poster[back_image_present]"

      assert_select "input[name=?]", "poster[read_download_present]"

      assert_select "input[name=?]", "poster[print_download_present]"

      assert_select "input[name=?]", "poster[lite_download_present]"

      assert_select "textarea[name=?]", "poster[slug]"

      assert_select "input[name=?]", "poster[height]"

      assert_select "input[name=?]", "poster[width]"
    end
  end
end
