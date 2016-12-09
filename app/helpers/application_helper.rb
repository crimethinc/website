module ApplicationHelper

  def link_to_dates(year: nil, month: nil, day: nil, show_year: true, show_month: true, show_day: true)
    show_month = false if month.nil?
    show_day   = false if day.nil?

    links = []

    month = month.to_s.rjust(2, "0") unless month.nil?
    day   = day.to_s.rjust(2, "0")   unless day.nil?

    if year && show_year
      links << link_to_unless_current(year,  articles_path(year),               rel: "archives", class: "year")
    end
    if month && show_month
      links << link_to_unless_current(month, articles_path(year, month),        rel: "archives", class: "month")
    end
    if day && show_day
      links << link_to_unless_current(day,   articles_path(year, month, day),   rel: "archives", class: "day")
    end

    links.join("-").html_safe
  end

  def page_title
    t(:site_name)
  end

  def lang
    # TODO
    "en"
  end

  def author
    t(:site_name)
  end

  def og_type
    "website"
  end

  def twitter_username
    "@crimethinc"
  end

  def twitter_user_id
    "14884161"
  end

  def apple_touch_icon_link_tags
    output = []

    # square pixel sizes
    sizes = [57, 60, 72, 76, 114, 120, 144, 152, 180]
    sizes.each do |size|
      dimensions = "#{size}x#{size}"
      href = setting("icon_#{dimensions}")
      output << tag(:link, rel: "apple-touch-icon", sizes: dimensions, href: href)
    end

    output.join("\n").html_safe
  end
end
