class ToChangeEverythingGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)
  argument :lang_code, type: :string, require: true
  argument :url, type: :string, require: true
  argument :lang_direction, type: :string, require: false, default: 'ltr',
                            description: 'the direction the language is' \
                                         'written/read: either ltr or rtl' \
                                         ' (default is ltr)'

  def add_tce_url_to_controller
    controller = 'app/controllers/to_change_everything_controller.rb'
    inject_into_file controller, after: '%w[' do
      "#{url} "
    end
  end

  def add_language_to_nav_menu_desktop
    controller = 'app/views/layouts/to_change_everything.html.erb'
    inject_into_file controller, after: '<ul id="language">' do
      "\n" \
      "              <%# TODO: make sure this div doesn't have duplicate urls %>\n" \
      "              <li><a href=\"/tce/#{url}\">#{url}</a></li>"
    end
  end

  def add_language_to_nav_menu_mobile
    controller = 'app/views/layouts/to_change_everything.html.erb'
    inject_into_file controller, after: '<div id="lang1">' do
      "\n" \
      "        <%# TODO: make sure this div doesn't have duplicate urls %>\n" \
      "        <li><a href=\"/tce/#{url}\">#{url} <span class=\"check check-#{url}\"></span></a></li>"
    end
  end

  def create_tce_css_file
    filepath = 'app/assets/stylesheets/to_change_everything/'
    template 'to_change_everything.scss.template', "#{filepath}_#{url}.scss"
    append_file 'app/assets/stylesheets/to_change_everything.scss',
                "@import \"to_change_everything/#{url}\";\n"
  end

  def copy_tce_en_file
    en_file = 'en.yml.template'
    new_file = "config/locales/to_change_everything/#{lang_code}.yml"
    template en_file, new_file
  end
end
