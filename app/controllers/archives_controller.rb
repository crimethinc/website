class ArchivesController < ApplicationController
  def index
    @html_id    = "page"
    @body_id    = "archives"
    @page_title = "Articles"

    @archive = Archive.new(year: params[:year], month: params[:month], day: params[:day], page: params[:page])

    # Redirect if showing this result set isn't useful
    if @archive.articles.length == 1 && @archive.day.present?
      return redirect_to @archive.articles.first.path
    elsif @archive.articles.length.zero?
      if    @archive.day.present?
        return redirect_to archives_path(@archive.year, @archive.month)
      elsif @archive.month.present?
        return redirect_to archives_path(@archive.year)
      elsif @archive.year.present?
        return redirect_to [:read]
      end
    end
  end
end
