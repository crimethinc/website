module LibraryHelper
  def image_tag_for_library_section articles
    slug = articles.first[:path].split('/').last
    section_featured_article = Article.find_by(slug: slug)

    image_tag section_featured_article.image, alt: section_featured_article.image_description
  end
end
