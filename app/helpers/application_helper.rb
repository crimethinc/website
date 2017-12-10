module ApplicationHelper

  def html_id
    "id='#{@html_id}'".html_safe if @html_id.present?
  end

  def body_id
    @body_id
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

  def largest_touch_icon_url
    size       = icon_sizes.last
    dimensions = "#{size}x#{size}"

    asset_url("icons/icon-#{dimensions}.png")
  end

end
