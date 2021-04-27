module Admin
  class DefinitionsController < Admin::AdminController
    def index
      @definitions = Definition.page(params[:page])
      @title       = admin_title
    end
  end
end
