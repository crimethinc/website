module AdminHelper
  def admin_form_date(post)
    tz = post&.published_at_tz
    return '' if tz.nil? || post.published_at.nil?

    post.published_at.in_time_zone(tz).strftime('%F')
  end

  def admin_form_time(post)
    tz = post&.published_at_tz
    return '' if tz.nil? || post.published_at.nil?

    post.published_at.in_time_zone(tz).strftime('%T')
  end

  def nav_to(text, path, *options)
    classes = ["nav-link"]

    unless options.blank?
      options = options.first
      if options[:no_css]
        classes  = [options[:class]]
      else
        classes << [options[:class]]
      end
    end

    classes << "active" if current_page?(path)

    content_tag :li, class: "nav-item" do
      link_to text, path, class: classes.join(" ")
    end
  end
end
