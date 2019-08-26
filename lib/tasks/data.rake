namespace :data do
  desc 'NOTE: Run only ONCE in production'
  task de_seed: :environment do
    puts "==> German articles: #{Article.where(locale: 'de').count}"
    puts

    json_path = File.expand_path('data/de_seed/json', __dir__)
    md_path   = File.expand_path('data/de_seed/md', __dir__)

    Dir.foreach(json_path).with_index do |json_file, _index|
      next if (json_file == '.') || (json_file == '..')

      puts "==> #{json_file}"

      meta = JSON.load File.new("#{json_path}/#{json_file}")

      title        = meta['title']
      subtitle     = meta['subtitle'] unless meta['subtitle'].blank?
      published_at = meta['published_at']

      md_file = json_file.sub('.json', '.md')

      content = IO.read("#{md_path}/#{md_file}")

      Article.create!(title:        title,
                      subtitle:     subtitle,
                      published_at: published_at,
                      content:      content,
                      locale:       'de')
    end

    puts
    puts "==> German articles: #{Article.where(locale: 'de').count}"
  end
end
