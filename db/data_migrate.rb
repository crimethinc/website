# rubocop:disable Metrics/MethodLength
class DataMigrate
  class << self
    def run
      Locale.find_each do |locale|
        locale.update! temp_language_direction: locale.language_direction
      end

      User.find_each do |locale|
        locale.update! temp_role: locale.role
      end

      # "publishable" tables
      Article.find_each do |publishable|
        publishable.update! temp_publication_status: publishable.publication_status
      end

      Book.find_each do |publishable|
        publishable.update! temp_publication_status: publishable.publication_status
      end

      Definition.find_each do |publishable|
        publishable.update! temp_publication_status: publishable.publication_status
      end

      Episode.find_each do |publishable|
        publishable.update! temp_publication_status: publishable.publication_status
      end

      Issue.find_each do |publishable|
        publishable.update! temp_publication_status: publishable.publication_status
      end

      Journal.find_each do |publishable|
        publishable.update! temp_publication_status: publishable.publication_status
      end

      Logo.find_each do |publishable|
        publishable.update! temp_publication_status: publishable.publication_status
      end

      Page.find_each do |publishable|
        publishable.update! temp_publication_status: publishable.publication_status
      end

      Poster.find_each do |publishable|
        publishable.update! temp_publication_status: publishable.publication_status
      end

      Sticker.find_each do |publishable|
        publishable.update! temp_publication_status: publishable.publication_status
      end

      Video.find_each do |publishable|
        publishable.update! temp_publication_status: publishable.publication_status
      end

      Zine.find_each do |publishable|
        publishable.update! temp_publication_status: publishable.publication_status
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
