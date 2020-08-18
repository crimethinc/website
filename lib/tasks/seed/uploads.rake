class ProductionAssetsSyncer
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
    end
  end

  # rubocop:disable Metrics/MethodLength
  def migrate_assets tool
    json_api_url = "#{API_URL_BASE}#{tool.path}.json"
    tool_json    = HTTP.get(json_api_url).to_s
    tool         = JSON.parse(tool_json)

    puts "==> #{json_api_url}"
    puts "==> #{klass}"
    pp tool
    puts

    return
    %i[image download].each do |kind|
      %i[front back].each do |side|
        %i[color black_and_white].each do |color|
          next unless tool.send("image_#{side}_#{color}_#{kind}").attached?

          puts "==>       Working on: #{tool.slug} - #{side} / #{color} / #{kind}"
          # asset URL
          url = if kind == :image
                  tool.image side: side, color: color
                else
                  tool.download_url side: side, color: color
                end

                puts url
                next

          # attach asset to new attribute
          attr_name = kind == :image ? "image_#{side}_#{color}_image" : "image_#{side}_#{color}_download"

          # don't reupload tools that're already uploaded
          if !Rails.env.development? && tool.send(attr_name).attached?
            puts "==>         Skipping: #{tool.slug} - #{side} / #{color} / #{kind}"
            puts
            next
          end

          # file name
          file_name = url.split('/').last

          # fetch asset, save to tmp
          puts "==> Downloading from: #{url}"
          puts "==>        Saving to: tmp/#{file_name}"
          open("tmp/#{file_name}", 'wb') do |file|
            file << URI.parse(url).open.read
          end

          puts "==>   Attaching file: #{file_name}"
          puts "==>               to: #{attr_name}"

          tool.send(attr_name).attach io: File.open("tmp/#{file_name}"), filename: file_name

          # delete tmp file
          puts "==>    Deleting file: tmp/#{file_name}"
          File.delete("tmp/#{file_name}") if File.exist? "tmp/#{file_name}"
          puts

          # try to not fail in production
          sleep 5 unless Rails.env.development?
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end

namespace :seed do
  namespace :uploads do
    desc 'Import ActiveStorage uploads from Production to Development'
    task import: %i[
      seed:uploads:import:books
      seed:uploads:import:issues
      seed:uploads:import:journals
      seed:uploads:import:logos
      seed:uploads:import:posters
      seed:uploads:import:stickers
      seed:uploads:import:zines
    ]

    namespace :import do
      desc 'Import books from Production to Development'
      task books: :environment do
        ProductionAssetsSyncer.new(:books).run
      end

      desc 'Import issues from Production to Development'
      task issues: :environment do
        ProductionAssetsSyncer.new(:issues).run
      end

      desc 'Import journals from Production to Development'
      task journals: :environment do
        ProductionAssetsSyncer.new(:journals).run
      end

      desc 'Import logos from Production to Development'
      task logos: :environment do
        ProductionAssetsSyncer.new(:logos).run
      end

      desc 'Import posters from Production to Development'
      task posters: :environment do
        ProductionAssetsSyncer.new(:posters).run
      end

      desc 'Import stickers from Production to Development'
      task stickers: :environment do
        ProductionAssetsSyncer.new(:stickers).run
      end

      desc 'Import zines from Production to Development'
      task zines: :environment do
        ProductionAssetsSyncer.new(:zines).run
      end
    end
  end
end
