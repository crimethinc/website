class ArchivesController < ApplicationController
  def index
    @html_id    = "page"
    @body_id    = "archives"
    @page_title = "Articles"

    @articles_year  = params[:year]
    @articles_month = params[:month]
    @articles_day   = params[:day]

    articles = Article.published.all

    articles = articles.where(year:  params[:year])  if params[:year].present?
    articles = articles.where(month: params[:month]) if params[:month].present?
    articles = articles.where(day:   params[:day])   if params[:day].present?

    # Redirect if showing this result set isn't useful
    if articles.length == 1
      return redirect_to articles.first.path
    elsif articles.length.zero?
      if    params[:day].present?
        return redirect_to archives_path(params[:year], params[:month])
      elsif params[:month].present?
        return redirect_to archives_path(params[:year])
      elsif params[:year].present?
        return redirect_to [:read]
      end
    end

    articles = articles.page(params[:page]).per(5)
    @archive = Archive.new(articles)
  end
end
