module ArticlesHelper

  def article_tag(article, &block)
    klasses = ["h-entry"]
    klasses << "article-with-no-header-image" if article.image.blank?

    content_tag "article", id: "article-#{article.id}", class: klasses.join(" "), role: "article", &block
  end

  def display_date(datetime=nil)
    unless datetime.nil?
      datetime.strftime("%Y-%m-%d")
    end
  end

  def display_time(datetime=nil)
    unless datetime.nil?
      datetime.strftime("%l:%M&nbsp;%z").html_safe
    end
  end

  def link_to_dates(year: nil, month: nil, day: nil, show_year: true, show_month: true, show_day: true)
    show_month = false if month.nil?
    show_day   = false if day.nil?

    links = []

    month = month.to_s.rjust(2, "0") unless month.nil?
    day   = day.to_s.rjust(2, "0")   unless day.nil?

    if year && show_year
      links << link_to_unless_current(year,  archives_path(year),               rel: "archives", class: "year")
    end
    if month && show_month
      links << link_to_unless_current(month, archives_path(year, month),        rel: "archives", class: "month")
    end
    if day && show_day
      links << link_to_unless_current(day,   archives_path(year, month, day),   rel: "archives", class: "day")
    end

    links.join("-").html_safe
  end

end
