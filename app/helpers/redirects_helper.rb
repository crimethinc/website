module RedirectsHelper

  def redirect_http_status_code(redirect)
    if redirect.temporary?
      content_tag(:span, "TEMPORARY", class: "label label-success") + "\n" +
      content_tag(:span, "302",       class: "label label-success")
    else
      content_tag(:span, "PERMANENT", class: "label label-default") + "\n" +
      content_tag(:span, "301",       class: "label label-default")
    end
  end

end
