class ArticleArchivesController < ApplicationController
  def index
    @html_id = 'page'
    @body_id = 'article-archives'
    @title   = PageTitle.new title_for :archives

    @article_archive = ArticleArchive.new(year:  params[:year],
                                          month: params[:month],
                                          day:   params[:day],
                                          page:  params[:page])

    # Redirect to somewhere else if showing this result set isn’t useful
    path =
      if @article_archive.articles.length == 1 && @article_archive.day.present?
        @article_archive.articles.first.path
      elsif @article_archive.articles.length.zero?
        if @article_archive.day.present?
          article_archives_path(@article_archive.year, @article_archive.month)
        elsif @article_archive.month.present?
          article_archives_path(@article_archive.year)
        elsif @article_archive.year.present?
          [:library]
        end
      end

    if path.present?
      redirect_to path
    else
      render "#{Current.theme}/article_archives/index"
    end
  end
end
