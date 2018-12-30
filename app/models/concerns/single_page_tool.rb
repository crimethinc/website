module SinglePageTool
  extend ActiveSupport::Concern
  include Tool

  def meta_image
    front_image
  end
end
