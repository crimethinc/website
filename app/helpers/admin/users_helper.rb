module Admin::UsersHelper
  def thing_type(thing)
    request.path.split('admin/').last.split('/').first.capitalize.singularize
  end
end
