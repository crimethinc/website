module AdminHelper
  def thing_type(_thing)
    request.path.split("admin/").last.split("/").first.capitalize.singularize
  end
end
