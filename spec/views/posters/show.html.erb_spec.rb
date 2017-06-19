require 'rails_helper'

RSpec.describe "posters/show", type: :view do
  before(:each) do
    @poster = assign(:poster, Poster.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Content Format/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Height/)
    expect(rendered).to match(/Width/)
  end
end
