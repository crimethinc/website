module SinglePageTool
  extend ActiveSupport::Concern
  include Tool
  include Featureable
  include Translatable

  def image_description
    I18n.t 'tools.poster.image_description', title: title
  end
  alias front_image_description image_description

  def back_image_description
    I18n.t 'tools.poster.image_description', title: title
  end

  def front_image
    # TODO
    image_url side: :front, color: preferred_front_image_color
  end
  alias meta_image front_image
  alias image front_image

  def download_url side: nil, color: nil
    url_of side: side, color: color, kind: :download
  end

  private

  # URL builders
  def image_url side: :front, color: :color
    url_of side: side, color: color, kind: :image
  end

  def url_of side:, color:, kind:
    Rails.application.routes.url_helpers.rails_blob_url send("image_#{side}_#{color}_#{kind}")
  end

  def preferred_front_image_color
    return :color           if image_front_color_image.attached?           || image_front_color_download.attached?
    return :black_and_white if image_front_black_and_white_image.attached? || image_front_black_and_white_download.attached?

    :color
  end

  def preferred_front_image_kind
    return :image    if front_image_present?
    return :download if front_download_present?

    :download
  end

  def front_color_image
    image_url side: :front, color: :color
  end

  def front_black_and_white_image
    image_url side: :front, color: :black_and_white
  end

  def back_color_image
    image_url side: :back, color: :color
  end

  def back_black_and_white_image
    image_url side: :back, color: :black_and_white
  end

  def front_image_present?
    image_front_color_image.attached? || image_front_black_and_white_image.attached?
  end

  def back_image_present?
    image_back_color_image.attached? || image_back_black_and_white_image.attached?
  end

  def front_download_present?
    image_front_color_download.attached? || image_front_black_and_white_download.attached?
  end

  def back_download_present?
    image_back_color_download.attached? || image_back_black_and_white_download.attached?
  end
end
