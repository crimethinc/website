class ArchivePaginator
  attr_reader :archive

  def initialize(archive)
    @archive = archive

    if archive.month.present?
      @current    = [archive.year.to_s, archive.month.to_s]
      @collection = months
    else
      @current    = archive.year.to_s
      @collection = years
    end
  end

  def previous?
    !!previous_value
  end

  def previous_path
    "/" + Array(previous_value).join("/")
  end

  def previous_label
    if @archive.month
      I18n.t("views.pagination.previous_month", month: previous_value.join("-")).html_safe
    else
      I18n.t("views.pagination.previous_year", year: previous_value).html_safe
    end
  end

  def next?
    !!next_value
  end

  def next_path
    "/" + Array(next_value).join("/")
  end

  def next_label
    if @archive.month
      I18n.t("views.pagination.next_month", month: next_value.join("-")).html_safe
    else
      I18n.t("views.pagination.next_year", year: next_value).html_safe
    end
  end

  private

  attr_reader :collection, :current

  def next_value
    return @next if defined?(@next)

    index = collection.reverse.find_index(current) + 1
    @next = collection.reverse[index]
  end

  def previous_value
    return @previous if defined?(@previous)

    index = collection.find_index(current) + 1
    @previous = collection[index]
  end

  def years
    @years ||= Article.pluck(:year).uniq
  end

  def months
    @months ||= Article.pluck(:year, :month).uniq
  end
end
