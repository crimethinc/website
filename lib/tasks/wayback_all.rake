desc 'Request the Wayback Machine to snapshot a ALL articles'

task :wayback_all, [:url] => :environment do |_t, args|
  app = JSON.parse(File.read(Rails.root.join('app.json')))
  api = 'https://pragma.archivelab.org/'

  urls = Article.published.map { |a| app['website'] + a.path }

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

    puts
  end
end
