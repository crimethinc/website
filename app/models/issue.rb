class Issue < ApplicationRecord
  include MultiPageTool

  belongs_to :journal

  def namespace
    'journals'
  end

  def path
    "/journals/#{journal.slug}/#{issue}"
  end

  def false_for_missing_methods
    false
  end

  alias front_color_image_present? false_for_missing_methods
  alias front_black_and_white_image_present? false_for_missing_methods
  alias back_color_image_present? false_for_missing_methods
  alias back_black_and_white_image_present? false_for_missing_methods
  alias front_color_download_present? false_for_missing_methods
  alias front_black_and_white_download_present? false_for_missing_methods
  alias back_color_download_present? false_for_missing_methods
  alias back_black_and_white_download_present? false_for_missing_methods
end
