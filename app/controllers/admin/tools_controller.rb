module Admin
  class ToolsController < Admin::AdminController
    before_action :set_ebook_formats, only: [:edit, :new]

    def edit; end

    def new; end

    def set_ebook_formats
      @ebook_formats = Tool::EBOOK_FORMATS
    end
  end
end
