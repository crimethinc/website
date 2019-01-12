desc 'Request the Wayback Machine to snapshot a specific URL or all new '\
     'article URLs for the past 24 hours if no argument is given'
task :wayback, [:url] => :environment do |_t, args|
  app = JSON.parse(File.read(Rails.root.join('app.json')))
  api = 'https://pragma.archivelab.org/'
  urls = []

  if args[:url]
    urls.append args[:url]
  else
    since = 1.day.ago.to_s
    Article.where("updated_at > '#{since}'").each do |article|
      urls.append [app['website'], article.path].join('')
    end
  end

  uri = URI.parse(api)
  urls.each do |url|
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request.body = JSON.dump('url' => url)

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
    if response.code == '200'
      r = JSON.parse(response.body)
      puts "#{url} => https://web.archive.org#{r['wayback_id']}"
    else
      puts "Snapshot ping for #{url} Failed"
      puts response.body
    end
  end
end
