class ArticleArchivesController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'article-archives'
    @title   = PageTitle.new title_for :archives

    # NOTE: @categories and @years are used on every page in the header search card
    #       each is set in a before_action in application_controller

    @article_archive = ArticleArchive.new(year:  params[:year],
                                          month: params[:month],
                                          day:   params[:day],
                                          page:  params[:page])

    @datetime = [@article_archive.year, @article_archive.month, @article_archive.day].compact.join '-'

    return redirect_to redirect_to_path if redirect_to_path.present?

    render "#{Current.theme}/article_archives/index"
  end

  private

  def redirect_to_path
    # Redirect to somewhere else if showing this result set isn’t useful
    if @article_archive.articles.length == 1 && @article_archive.day.present?
      @article_archive.articles.first.path
    elsif @article_archive.articles.empty?
      if @article_archive.day.present?
        article_archives_path(@article_archive.year, @article_archive.month)
      elsif @article_archive.month.present?
        article_archives_path(@article_archive.year)
      elsif @article_archive.year.present?
        :library
      end
    end
  end
end
