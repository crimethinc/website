class ToChangeEverythingGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)
  argument :lang_code, type: :string, require: true
  argument :lang_name, type: :string, require: true

  argument :lang_direction,
           type:        :string,
           require:     false,
           default:     'ltr',
           description: 'Direction the language is written/read: either ltr or rtl (default is ltr)'

  def add_lang_name_to_tce_controller
    controller = 'app/controllers/to_change_everything_controller.rb'
    inject_into_file controller, after: "TO_CHANGE_ANYTHING_YAMLS = %w[\n" do
      "    #{lang_name}\n"
    end
  end

  def add_lang_name_to_application_config
    app_config = 'config/application.rb'

    if lang_direction.casecmp('ltr').zero?
      after_this_text  = "path_ltr_locales = %i[\n"
      inject_this_text = "      #{lang_name}\n"
    else
      after_this_text  = 'path_rtl_locales = %i['
      inject_this_text = "#{lang_name} "
    end

    inject_into_file app_config, after: after_this_text do
      inject_this_text
    end
  end

  def add_language_to_nav_menu_desktop
    # TODO: change this to inject into app/helpers/to_change_everything_helper.rb

    # layout = 'app/views/layouts/to_change_everything.html.erb'
    # inject_into_file layout, after: '<ul id="language">' do
    #   <<-ERB
    #
    #             <%# TODO: make sure this div doesn’t have duplicate URLs %>
    #             <li><a href='/tce/#{lang_name}'>#{lang_name}</a></li>
    #   ERB
    # end
  end

  def add_language_to_nav_menu_mobile
    # TODO: change this to inject into app/helpers/to_change_everything_helper.rb

    # layout = 'app/views/layouts/to_change_everything.html.erb'
    # inject_into_file layout, after: '<div id="lang1">' do
    #   <<-ERB
    #
    #       <%# TODO: make sure this div doesn’t have duplicate URLs %>
    #       <li><a href='/tce/#{lang_name}'>#{lang_name} <span class='check check-#{lang_name}'></span></a></li>
    #   ERB
    # end
  end

  def create_tce_css_file
    template 'to_change_everything.scss.template',
             "app/assets/stylesheets/to_change_everything/_#{lang_name}.scss"

    append_file 'app/assets/stylesheets/to_change_everything.scss',
                "@import 'to_change_everything/#{lang_name}';\n"
  end

  def copy_tce_en_file
    en_file = 'en.yml.template'
    new_file = "config/locales/to_change_everything/#{lang_code}.yml"
    template en_file, new_file
  end
end
