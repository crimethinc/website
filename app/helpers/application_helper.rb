module ApplicationHelper
  def site_mode
    lite_mode? ? 'lite' : 'media'
  end

  def icon_sizes
    [57, 60, 70, 72, 76, 114, 120, 144, 150, 152, 180, 192, 200, 300, 310, 500, 600]
  end

  def largest_touch_icon_url
    size       = icon_sizes.last
    dimensions = "#{size}x#{size}"

    asset_url("icons/icon-#{dimensions}.png")
  end

  def render_themed path, options = {}
    render "#{Theme.name}/#{path}", options
  end
end
