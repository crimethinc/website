class Poster < ApplicationRecord
  include SinglePageTool

  has_one_attached :image_front_color_image
  has_one_attached :image_front_black_and_white_image
  has_one_attached :image_back_color_image
  has_one_attached :image_back_black_and_white_image
  has_one_attached :image_front_color_download
  has_one_attached :image_front_black_and_white_download
  has_one_attached :image_back_color_download
  has_one_attached :image_back_black_and_white_download
end
