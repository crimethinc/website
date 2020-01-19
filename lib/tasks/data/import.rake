require 'yaml'

# IMPORTANT!
# One time use data import / migration tasks
# Delete its support files after its run in production

namespace :data do
  namespace :translations do
    desc 'Import translated articles'
    task :import, [:locale_lang_code] => :environment do |_, args|
      assign_locale! args

      article_from_data_files do |translated_article|
        next if translated_article.blank?

        english_article_id = translated_article['canonical_id']
        english_article    = Article.find(english_article_id)

        if english_article.blank?
          puts
          puts "==> WARNING: No article found with ID: #{english_article_id}! Skipping."
          puts
          next
        end

        next if english_article.localizations.pluck(:locale).include?(locale)

        # Clean YAML before making a new article
        # translation_tags = TODO
        translated_article.delete 'tags'
        translated_article.delete 'canonical_url'

        # Create the translated article draft
        article = Article.new translated_article

        article.locale             = locale
        article.publication_status = 'draft'

        article.image             = english_article.image
        article.image_description = english_article.image_description
        article.published_at      = english_article.published_at

        article.save!

        # Only set a new short path if there is one on the EN article
        article.update short_path: "#{english_article.short_path}-#{locale}" if english_article.short_path.present?

        puts "==> Saved article: #{article.id}"

        # Add tags and categories
        article.tags       << english_article.tags
        article.categories << english_article.categories
      end
    end
  end
end

def article_from_data_files
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

def print_missing_data_files_error
  error = <<~ERROR
    ==> ERROR: Missing data files directory at: lib/tasks/#{locale}
        ----------------------------------------------------
    ==> This task needs a folder of YAML and Markdown file pairs
    ==> Eg, 1.yml 1.md
    ==> MD:   Only the article's content in Markdown
    ==> YAML: Flat key/value pairs of article's meta data
  ERROR

  puts
  puts error
  puts
  exit 1
end

def data_dir
  Dir.new File.expand_path(locale, __dir__)
rescue Errno::ENOENT
  print_missing_data_files_error
end

def assign_locale! args
  @locale = args[:locale_lang_code]
end

# rubocop:disable Style/TrivialAccessors
def locale
  @locale
end
# rubocop:enable Style/TrivialAccessors
