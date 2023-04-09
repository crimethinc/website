class WaybackMachineArchiver
  def run url: nil
    if url.present?
      run_for_one page_url: url
    else
      run_for_all
    end
  end

  private

  def run_for_one page_url:
    app = JSON.parse(Rails.root.join('app.json').read)
    api = 'https://pragma.archivelab.org/'
    urls = []

    if page_url
      urls.append page_url
    else
      since = 1.day.ago.to_s
      Article.where("updated_at > '#{since}'").find_each do |article|
        urls.append [app['website'], article.path].join
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
        Rails.logger.debug { "#{url} => https://web.archive.org#{r['wayback_id']}" }
      else
        Rails.logger.debug { "Snapshot ping for #{url} Failed" }
        Rails.logger.debug response.body
      end
    end
  end

  def run_for_all
    app = JSON.parse(Rails.root.join('app.json').read)
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
        Rails.logger.debug { "#{url} => https://web.archive.org#{r['wayback_id']}" }
      else
        Rails.logger.debug { "Snapshot ping for #{url} Failed" }
        Rails.logger.debug response.body
      end

      Rails.logger.debug
    end
  end
end
