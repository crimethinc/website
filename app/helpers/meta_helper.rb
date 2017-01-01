module MetaHelper

  def find_the_thing
    @find_the_thing ||= [@article, @page, @podcast, @episode].compact.first
  end

  def meta_type(thing)
    thing.present? ? "article" : og_type
  end

  def meta_title(thing)
    thing.present? ? thing.title : t("head.meta_title")
  end

  def meta_description(thing)
    thing.present? ? thing.meta_description : t("head.meta_description")
  end

  def meta_image(thing)
    if thing.present?
      thing.image || "https://http.cat/502.jpg" # TODO
    else
      "https://http.cat/502.jpg" # TODO
    end
  end
end
