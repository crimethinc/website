module SinglePageTool
  extend ActiveSupport::Concern
  include Tool
  include Featureable
  include Translatable
  include Publishable

  def image_description
    I18n.t 'tools.poster.image_description', title: title
  end
  alias front_image_description image_description

  def back_image_description
    I18n.t 'tools.poster.image_description', title: title
  end

  def front_image
    image side: :front, color: preferred_front_image_color
  end
  alias meta_image front_image

  def download_url side: nil, color: nil
    url_of side: side, color: color, kind: :download
  end

  def image side: :front, color: :color
    if prefer_image_for_preview?
      image_permutation = send(:"image_#{side}_#{color}_image")
      send(:"image_#{side}_black_and_white_image") unless image_permutation.attached?

      image_permutation
    else
      url_of side: side, color: color, kind: preferred_front_image_kind
    end

  # in development/staging we often download production data and load
  # it into our local database to facilitate development and
  # debugging. This causes an error with image and resources that are
  # uploaded via ActiveStorage. We get the below error whenever trying
  # to generate an image url:
  #
  #  ActionView::Template::Error (undefined method `signed_id' for nil:NilClass):
  #
  # This is because the development/staging ActiveStorage tables don't
  # (and cannot) match up with the actual ActiveStorage storage used
  # in these environments (e.g. the staging env points to aa different
  # # AWS instance than the production env)
  #
  # This is a bit of a stopgap until we figure out a better way of
  # handling this issue.
  rescue StandardError => e
    # Rails environment is production in our staging environment for
    # heroku reasons. We have environment variables set to distinguish
    # between the two.
    throw e if Rails.env.production? && Rails.application.config.x.app.on_production
    ''
  end

  def prefer_image_for_preview?
    preferred_front_image_kind == :image
  end

  private

  def url_of side:, color:, kind:
    Rails.application.routes.url_helpers.rails_blob_url send(:"image_#{side}_#{color}_#{kind}")
  end

  def preferred_front_image_color
    return :color if image_front_color_image.attached? || image_front_color_download.attached?

    if image_front_black_and_white_image.attached? || image_front_black_and_white_download.attached?
      return :black_and_white
    end

    :color
  end

  def preferred_front_image_kind
    return :image    if front_image_present?
    return :download if front_download_present?

    :download
  end

  def front_color_image
    image side: :front, color: :color
  end

  def front_black_and_white_image
    image side: :front, color: :black_and_white
  end

  def back_color_image
    image side: :back, color: :color
  end

  def back_black_and_white_image
    image side: :back, color: :black_and_white
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
