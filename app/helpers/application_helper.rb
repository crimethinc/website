module ApplicationHelper

  def page_title
    if @title.present?
      t(:site_name) + prepend_admin_if_needed + @title
    else
      t(:site_name)
    end
  end

  def lang
    # TODO
    "en"
  end

  def html_id
    @html_id
  end

  def body_id
    @body_id
  end

  def author
    t(:site_author)
    # TODO make this article author aware
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

  def br_to_p(html)
    simple_format(html, {}, sanitize: false).gsub("\n<br />", "</p><p>").html_safe
  end

  private

  def prepend_admin_if_needed
    if controller_path.match(/\Aadmin\/.*\z/).present?
      " #{t('admin.title_prepend')} : "
    else
      ' : '
    end
  end
end
