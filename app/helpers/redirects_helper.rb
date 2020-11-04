module RedirectsHelper
  def redirect_http_status_code redirect
    if redirect.temporary?
      tag.span 'TEMPORARY 302', class: 'badge bg-warning'
    else
      tag.span 'PERMANENT 301', class: 'badge bg-success text-white'
    end
  end
end
