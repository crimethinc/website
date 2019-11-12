module Admin
  class ArticlesController < Admin::AdminController
    before_action :set_article,      only: %i[show edit update destroy]
    before_action :set_published_at, only: %i[create update]
    before_action :set_categories,   only: %i[new edit]
    after_action  :organize_article, only: %i[create update]

    def index
      @articles = Article.root.includes(:collection_posts).page(params[:page])
      @title    = admin_title
    end

    def show
      # TODO: this is a hack
      @collection = Article.find(@article.collection_id) if @article.collection_id.present?

      @title   = admin_title(@article, %i[title subtitle])
      @html_id = 'js-admin-article'
      @body_id = 'top'
    end

    def new
      @collection = Article.find(params[:id]) if params[:id]
      @article    = Article.new

      @title   = admin_title
      @html_id = 'js-admin-article'
    end

    def edit
      @collection = Article.find(@article.collection_id) if @article.in_collection?
      @title      = admin_title(@article, %i[id title subtitle])
      @html_id    = 'js-admin-article'
    end

    def create
      @article = Article.new(article_params)

      if @article.save
        redirect_to [:admin, @article], notice: 'Article was successfully created.'
      else
        render :new
      end
    end

    def update
      @article.tags.destroy_all

      if @article.update(article_params)
        # Bust the article cache to update list of translations on articles
        @article.localizations.each(&:touch)

        redirect_to [:admin, @article], notice: 'Article was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      return redirect_to [:admin, @article] unless current_user.can_delete?

      @article.destroy
      redirect_to %i[admin articles], notice: 'Article was successfully destroyed.'
    end

    private

    def set_article
      if params[:year] && params[:slug]
        @article = Article.where(year: params[:year]).where(month: params[:month]).where(day: params[:day]).where(slug: params[:slug]).first

        redirect_to([:edit, :admin, @article])
      elsif params[:draft_code].present?
        @article = Article.find_by(draft_code: params[:draft_code])
        redirect_to([:edit, :admin, @article])
      else
        @article = Article.find(params[:id])
      end
    end

    def set_categories
      @categories = Category.all
    end

    def organize_article
      tag_assigner = TagAssigner.parse_glob(params[:tags])
      tag_assigner.assign_tags_to!(@article) if tag_assigner.present?
    end

    def article_params
      permitted_params = params.require(:article).permit(
        :title, :subtitle, :content, :year, :month, :day, :tweet, :slug,
        :draft_code, :summary, :published_at, :tags, :collection_id,
        :short_path, :image, :css, :image_description, :image_mobile,
        :published_at_tz, :locale, :canonical_id, :publication_status,
        category_ids: []
      )

      # if the `publish_now` submit button was used, we should see
      # that name show up in the raw params, we will set the
      # `published_at` to `Time.zone.now` and the `publication_status`
      # to 'published'
      handle_publish_now_situation(permitted_params) if params[:publish_now].present?

      handle_published_without_datetime permitted_params

      return permitted_params if current_user.can_publish? || @article&.published?

      # Override publication_status from the submitted for,
      # to prevent authors and editors from publishing a draft article
      permitted_params.merge(publication_status: 'draft') if @article.blank? || @article.draft?
    end

    def handle_publish_now_situation permitted_params, time: Time.zone.now, zone: Time.zone.name
      return permitted_params unless current_user.can_publish?
      return permitted_params if @article&.published?

      permitted_params.merge!(
        publication_status: 'published',
        published_at:       time,
        published_at_tz:    zone
      )
    end

    def handle_published_wo_datetime permitted_params
      return if @article&.published?

      publish_in_100_years = permitted_params[:publication_status] == 'published' &&
                             permitted_params[:published_at].blank?

      time = Time.zone.now + 100.years
      tz = Time.zone.name

      handle_publish_now_situation(permitted_params, time: time, zone: tz) if publish_in_100_years
    end
  end
end
