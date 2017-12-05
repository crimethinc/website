FactoryBot.define do
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
    front_color_image_present false
    back_color_image_present false
    slug "MyText"
    height "MyString"
    width "MyString"
  end

  trait :sticker do
    sticker true
  end
end
