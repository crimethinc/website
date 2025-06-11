Kaminari.configure do |config|
  # config.default_per_page = 25
  # config.max_per_page = nil
  config.window = 1
  config.outer_window = 3
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
  # config.max_pages = nil
  config.params_on_first_page = true # forces /page/1 instead of /
end
