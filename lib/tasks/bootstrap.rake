namespace :bootstrap do
  desc 'Check for Bootstrap updates and download if newer version available'
  task download: :environment do
    require 'down'
    require 'json'

    version_file = Rails.root.join '.bootstrap-version'
    current_version = version_file.exist? ? version_file.read.strip : '0.0.0'

    print 'Checking for Bootstrap updates... '

    response       = HTTP.get 'https://api.github.com/repos/twbs/bootstrap/releases/latest'
    latest         = JSON.parse response.body.to_s
    latest_version = latest['tag_name'].delete_prefix 'v'

    puts "updating from #{current_version} to #{latest_version}"

    css_url     = "https://cdn.jsdelivr.net/npm/bootstrap@#{latest_version}/dist/css/bootstrap.css"
    css_map_url = "https://cdn.jsdelivr.net/npm/bootstrap@#{latest_version}/dist/css/bootstrap.css.map"

    css_dir = Rails.root.join 'app/assets/stylesheets/vendor'

    FileUtils.mkdir_p css_dir

    Down.download css_url,     destination: css_dir.join('bootstrap.css').to_s
    Down.download css_map_url, destination: css_dir.join('bootstrap.css.map').to_s

    version_file.write "#{latest_version}\n"
    puts "Bootstrap CSS #{latest_version} downloaded to #{css_dir}"
  end
end
