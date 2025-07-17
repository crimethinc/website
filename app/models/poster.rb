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

  # TEMP: duplicate of #image, for now (2025-07-17)
  def meta_image
    return if preferred_front_image.blank?

    Rails.application.routes.url_helpers.rails_blob_url preferred_front_image
  end

  # TEMP: duplicate of #meta_image, for now (2025-07-17)
  def image
    return if preferred_front_image.blank?

    Rails.application.routes.url_helpers.rails_blob_url preferred_front_image
  end

  private

  def preferred_front_image
    return image_front_color_image           if image_front_color_image.attached?
    return image_front_black_and_white_image if image_front_black_and_white_image.attached?
    return image_back_color_image            if image_back_color_image.attached?
    return image_back_black_and_white_image  if image_back_black_and_white_image.attached?

    nil
  end
end
