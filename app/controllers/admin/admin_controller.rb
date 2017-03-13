class Admin::AdminController < ApplicationController
  layout "admin"

  def admin_title(model=nil, keys = [])
    return t(".#{action_name}_title", default: '') unless model.present?

    translation_vars = {}

    keys.each_with_object(translation_vars) do |key, hash|
      hash[key] = model.send(key)
    end

    t(".#{action_name}_title", translation_vars)
  rescue NoMethodError
    logger.error "#{controller_path}:#{action_name} has an issue with the page title"
    return ''
  end
end
