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
end
