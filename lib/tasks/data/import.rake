require 'yaml'

LOCALE             = 'pl'.freeze
PUBLICATION_STATUS = 'draft'.freeze

# IMPORTANT One time use data import / migration tasks
#           Delete each rake task and its support files after its run in production
namespace :data do
  namespace :translations do
    desc 'Import translated articles'
    task import: :environment do
      article_from_data_files.each do |translated_article|
        english_article_id = translated_article.with_indifferent_access[:canonical_id]
        english_article    = Article.find(english_article_id)

        if english_article.blank?
          puts
          puts "==> WARNING: No article found with ID: #{english_article_id}! Skipping."
          puts
          next
        end

        next if english_article.localizations.pluck(:locale).include?(locale)

        # Create the translated article draft
        article = Article.new translated_article

        article.locale             = locale
        article.publication_status = publication_status

        article.image        = english_article.image
        article.published_at = english_article.published_at
        article.short_path   = "#{english_article.short_path}-#{locale}"

        article.save!
      end
    end
  end
end

def locale
  LOCALE
end

def publication_status
  PUBLICATION_STATUS
end

def article_from_data_files
  data_dir = Dir.new File.expand_path('polish_import', __dir__)
  articles = {}

  data_dir.each do |data_file|
    next if %w[. ..].include? data_file

    file_path = File.expand_path(data_file, data_dir)
    file_name, extension = data_file.split '.'

    articles[file_name] = {} if articles[file_name].nil?

    case extension
    when 'yaml'
      metadata = YAML.load_file file_path

      articles[file_name] = articles[file_name].merge(metadata)
    when 'md'
      content = File.read file_path

      articles[file_name][:content] = content
    end
  end

  articles.values
end
