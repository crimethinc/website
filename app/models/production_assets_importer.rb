class ProductionAssetsImporter
  attr_reader :klass

  API_URL_BASE = 'https://crimethinc.com'.freeze

  def initialize klass
    @klass = klass
  end

  def run
    return if Rails.env.production?

    case klass
    when :posters
      Poster.find_each  { |poster|  migrate_assets(poster) }
    when :stickers
      Sticker.find_each { |sticker| migrate_assets(sticker) }
    when :logos
      Logo.find_each { |logo| migrate_assets(logo) }
    end
  end

  def migrate_assets local_tool
    remote_tool_url  = "#{API_URL_BASE}#{local_tool.path}.json"
    remote_tool_json = HTTP.get(remote_tool_url).to_s
    remote_tool_data = JSON.parse(remote_tool_json).with_indifferent_access

    Rails.logger.debug
    Rails.logger.debug '*' * 80
    Rails.logger.debug { "==> #{remote_tool_url}" }
    Rails.logger.debug

    remote_tool_data[:attachments].each do |key, url|
      attr_name = "image_#{key}"

      # nothing to import from production
      next if url.blank?

      Rails.logger.debug { "==>       Working on: #{local_tool.slug} - #{attr_name}" }

      # don't reupload tools that're already uploaded
      if local_tool.send(attr_name).attached?
        Rails.logger.debug { "==>         Skipping: #{attr_name}" }
        next
      end

      # file name
      file_name = url.split('/').last

      # fetch asset, save to tmp
      Rails.logger.debug { "==> Downloading from: #{url}" }
      Rails.logger.debug { "==>        Saving to: tmp/#{file_name}" }
      open("tmp/#{file_name}", 'wb') do |file|
        file << URI.parse(url).open.read
      end

      Rails.logger.debug { "==>   Attaching file: #{file_name}" }
      Rails.logger.debug { "==>               to: #{attr_name}" }

      local_tool.send(attr_name).attach io: File.open("tmp/#{file_name}"), filename: file_name

      # delete tmp file
      Rails.logger.debug { "==>    Deleting file: tmp/#{file_name}" }
      FileUtils.rm_rf("tmp/#{file_name}")
      Rails.logger.debug
    end

    sleep 2
  end
end
