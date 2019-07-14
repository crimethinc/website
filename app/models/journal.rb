class Journal < ApplicationRecord
  include MultiPageTool

  has_many :issues, dependent: :destroy

  default_scope { order(published_at: :desc) }

  def path
    "/journals/#{slug}"
  end

  def meta_description
    subtitle || description
  end

  def false_for_missing_methods
    false
  end

  alias back_image_present? false_for_missing_methods
  alias screen_two_page_view_download_present false_for_missing_methods
  alias screen_single_page_view_download_present false_for_missing_methods
  alias print_color_download_present false_for_missing_methods
  alias print_black_and_white_download_present false_for_missing_methods
  alias print_color_a4_download_present false_for_missing_methods
  alias print_black_and_white_a4_download_present false_for_missing_methods
  alias lite_download_present false_for_missing_methods
  alias epub_download_present false_for_missing_methods
  alias mobi_download_present false_for_missing_methods
  alias width false_for_missing_methods
  alias height false_for_missing_methods
  alias weight false_for_missing_methods
  alias pages false_for_missing_methods
  alias words false_for_missing_methods
  alias illustrations false_for_missing_methods
  alias photographs false_for_missing_methods
  alias printing false_for_missing_methods
  alias ink false_for_missing_methods
  alias definitions false_for_missing_methods
  alias recipes false_for_missing_methods
  alias cover_style false_for_missing_methods
  alias binding_style false_for_missing_methods
  alias has_index? false_for_missing_methods
  alias table_of_contents false_for_missing_methods
  alias gallery_images_count false_for_missing_methods
end
