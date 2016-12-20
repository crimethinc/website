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

  def slug
    @slug
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

  def icon_sizes
    [57, 60, 70, 72, 76, 114, 120, 144, 150, 152, 180, 192, 200, 300, 310, 500, 600]
  end

  def apple_touch_icon_link_tags
    output = []

    # square pixel sizes
    icon_sizes.each do |size|
      dimensions = "#{size}x#{size}"
      href = asset_path("icons/icon-#{dimensions}.png")
      output << tag(:link, rel: "apple-touch-icon icon", sizes: dimensions, href: href)
    end

    output.join("\n").html_safe
  end

  def br_to_p(html)
    simple_format(html, {}, sanitize: false).gsub("\n<br />", "</p><p>").html_safe
  end

  def homepage?
    @homepage = true
  end
end
