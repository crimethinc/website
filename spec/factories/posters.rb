FactoryGirl.define do
  factory :poster do
    sticker false
    title "MyText"
    subtitle "MyText"
    content "MyText"
    content_format "MyString"
    buy_info "MyText"
    buy_url "MyText"
    price_in_cents 1
    summary "MyText"
    description "MyText"
    front_image_present false
    back_image_present false
    slug "MyText"
    height "MyString"
    width "MyString"
  end
end
