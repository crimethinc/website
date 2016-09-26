module Admin::ArticlesHelper
  def page_or(article)
    article.page? ? 'page' : 'article'
  end

  def pages_or(article)
    page_or(article).pluralize
  end
end
