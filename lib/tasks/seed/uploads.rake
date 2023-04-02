namespace :seed do
  namespace :uploads do
    desc 'Delete all uploads/attachments from all tools in local database'
    task purge: :environment do
      attr_names = %i[
        image_jpg image_png image_pdf image_svg image_tif
        image_front_color_image image_front_black_and_white_image
        image_back_color_image image_back_black_and_white_image
        image_front_color_download image_front_black_and_white_download
        image_back_color_download image_back_black_and_white_download
      ]
      klasses = [Logo, Poster, Sticker]

      klasses.each do |klass|
        klass.find_each do |tool|
          attr_names.each do |attr_name|
            if tool.respond_to? attr_name
              puts "==> Purging: #{attr_name} from #{tool.slug}"
              tool.send(attr_name).purge
            end
          end
        end
      end
    end

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
        # TODO
        ProductionAssetsImporter.new(:books).run
      end

      desc 'Import issues from Production to Development'
      task issues: :environment do
        # TODO
        ProductionAssetsImporter.new(:issues).run
      end

      desc 'Import journals from Production to Development'
      task journals: :environment do
        # TODO
        ProductionAssetsImporter.new(:journals).run
      end

      desc 'Import logos from Production to Development'
      task logos: :environment do
        ProductionAssetsImporter.new(:logos).run
      end

      desc 'Import posters from Production to Development'
      task posters: :environment do
        ProductionAssetsImporter.new(:posters).run
      end

      desc 'Import stickers from Production to Development'
      task stickers: :environment do
        ProductionAssetsImporter.new(:stickers).run
      end

      desc 'Import zines from Production to Development'
      task zines: :environment do
        # TODO
        ProductionAssetsImporter.new(:zines).run
      end
    end
  end
end
