module Admin
  class JournalsController < Admin::ToolsController
    before_action :set_journal, only: %i[show edit update destroy]

    def index
      @journals = Journal.order(slug: :asc).page(params[:page])
      @title    = admin_title
    end

    def show
      @title = admin_title(@journal, %i[title subtitle])
    end

    def new
      @journal = Journal.new
      @title   = admin_title
    end

    def edit
      @title = admin_title(@journal, %i[id title subtitle])
    end

    def create
      @journal = Journal.new(journal_params)

      if @journal.save
        redirect_to [:admin, @journal], notice: 'Journal was successfully created.'
      else
        render :new
      end
    end

    def update
      if @journal.update(journal_params)
        redirect_to [:admin, @journal], notice: 'Journal was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @journal.destroy
      redirect_to %i[admin journals], notice: 'Journal was successfully destroyed.'
    end

    private

    def set_journal
      @journal = Journal.find(params[:id])
    end

    def journal_params
      params.require(:journal).permit(:title, :subtitle, :description, :locale)
    end
  end
end
