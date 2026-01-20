module Admin
  class ArticlesController < Admin::AdminController
    before_action :set_article,      only: %i[show edit update destroy]
    before_action :set_published_at, only: %i[create update]
    before_action :set_categories,   only: %i[new edit update]
    after_action  :organize_article, only: %i[create update]

    def index
      @articles = Article.published.english.root.includes(:collection_posts).page(params[:page]).per(10)
      @title    = admin_title
    end

    def draft
      @articles = Article.reorder(updated_at: :desc).draft.root.page(params[:page])

      # TEMP: workaround, for now
      @title    = PageTitle.new %i[Admin Articles Draft]
    end

    def show
      # TODO: this is a hack
      @collection = Article.find(@article.collection_id) if @article.collection_id.present?

      @title   = admin_title(@article, %i[title subtitle])
      @body_id = 'top'
    end

    def new
      @collection = Article.find(params[:id]) if params[:id]
      @article    = Article.new
      prepare_article_for_translation

      @title = admin_title
    end

    def edit
      @collection = Article.find(@article.collection_id) if @article.in_collection?
      @title      = admin_title(@article, %i[id title subtitle])
    end

    def create
      @article = Article.new article_params
      populate_content_from_docx_upload!

      if @article.save
        redirect_to [:admin, @article], notice: t('.notice')
      else
        render :new
      end
    end

    def update
      populate_content_from_docx_upload!
      @article.tags.destroy_all

      if @article.update article_params
        # Bust the article cache to update list of translations on articles
        @article.localizations.each(&:touch)

        redirect_to [:admin, @article], notice: t('.notice')
      else
        render :edit
      end
    end

    def destroy
      return redirect_to [:admin, @article] unless Current.user.can_delete?

      @article.destroy
      redirect_to %i[admin articles], notice: t('.notice')
    end

    private

    def populate_content_from_docx_upload!
      # TEMP: Spike to explore .docx uploads for article content
      #       This will get moved out to its own object
      return if params[:article][:word_doc].blank?

      # Convert the temp file to HTML first to make for better conversion to Markdown
      word_doc_content   = params[:article][:word_doc].read.force_encoding('UTF-8')
      html_from_word_doc = PandocRuby.convert word_doc_content, from: :docx, to: :html

      # Convert using ReverseMarkdown because it does a better job than pandoc
      markdown_from_html = ReverseMarkdown.convert html_from_word_doc, github_flavored: true

      # Groom the markdown a bit to be easier for author to work with
      markdown_from_html = markdown_from_html.strip
                                             .prepend("\n")
                                             .gsub("\n**", "\n# **")
                                             .gsub("\n_ ", "\n_")
                                             .gsub(" _\n", "_\n")
                                             .gsub('_\>', '> _')
                                             .gsub('\>', '>')
                                             .gsub('\\_', '_')
                                             .gsub('\*', '*')
                                             .gsub("- \n\n> ", '- ')
                                             .strip

      # Populate Aricle#content with the markdown
      params[:article][:content] = markdown_from_html
      @article.content           = markdown_from_html
      # /TEMP
    end

    def prepare_article_for_translation
      # Prefill and clean article for translation
      return if params[:canonical_id].blank?

      canonical_article = Article.find(params[:canonical_id])
      @article          = canonical_article.dup

      @article.canonical_id       = canonical_article.id
      @article.locale             = params[:locale]
      @article.short_path         = nil
      @article.publication_status = 'draft'

      @article.tags       = canonical_article.tags
      @article.categories = canonical_article.categories
    end

    def set_article
      if params[:year] && params[:slug]
        @article = Article.where(year:  params[:year])
                          .where(month: params[:month])
                          .where(day:   params[:day])
                          .where(slug:  params[:slug])
                          .first

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
      tag_assigner.presence&.assign_tags_to!(@article)
    end

    def article_params
      permitted_params = params.expect article: [
        :title, :subtitle, :content, :notes, :year, :month, :day, :tweet, :slug,
        :draft_code, :summary, :published_at, :tags, :collection_id,
        :short_path, :image, :css, :image_description, :image_mobile,
        :published_at_tz, :locale, :canonical_id, :publication_status,
        :word_doc, :featured_status, :featured_at, { category_ids: [] }
      ]

      # if the `publish_now` submit button was used, we should see
      # that name show up in the raw params, we will set the
      # `published_at` to `Time.zone.now` and the `publication_status`
      # to 'published'
      handle_publish_now_situation(permitted_params) if params[:publish_now].present?

      handle_published_without_datetime permitted_params

      return permitted_params if Current.user.can_publish? || @article&.published?

      # Override publication_status from the submitted for,
      # to prevent authors and editors from publishing a draft article
      permitted_params.merge(publication_status: 'draft') if @article.blank? || @article.draft?
    end

    def handle_publish_now_situation permitted_params, time: Time.zone.now, zone: Time.zone.name
      return permitted_params unless Current.user.can_publish?
      return permitted_params if @article&.published?

      permitted_params.merge!(
        publication_status: 'published',
        published_at:       time,
        published_at_tz:    zone
      )
    end

    def handle_published_without_datetime permitted_params
      return if @article&.published?

      publish_in_100_years = permitted_params[:publication_status] == 'published' &&
                             permitted_params[:published_at].blank?

      time = 100.years.from_now
      tz = Time.zone.name

      handle_publish_now_situation(permitted_params, time: time, zone: tz) if publish_in_100_years
    end
  end
end
