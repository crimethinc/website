module AdminHelper
  def current_resource_name
    request.path.split("admin/").last.split("/").first.capitalize.singularize
  end
end
