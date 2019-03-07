module RedirectsHelper
  def redirect_http_status_code(redirect)
    if redirect.temporary?
      tag.span 'TEMPORARY 302', class: 'badge badge-warning'
    else
      tag.span 'PERMANENT 301', class: 'badge badge-success'
    end
  end
end
