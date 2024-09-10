# rubocop:disable Metrics/MethodLength
class DataMigrate
  class << self
    def run
      # locales
      Locale.find_each do |locale|
        locale.update! temp_language_direction: locale.language_direction
      end

      # users
      User.find_each do |user|
        user.update! temp_role: user.role
      end

      # "publishable" tables
      Article.find_each do |article|
        article.update! temp_publication_status: article.publication_status
      end

      Book.find_each do |book|
        book.update! temp_publication_status: book.publication_status
      end

      Definition.find_each do |definition|
        definition.update! temp_publication_status: definition.publication_status
      end

      Episode.find_each do |episode|
        episode.update! temp_publication_status: episode.publication_status
      end

      Issue.find_each do |issue|
        issue.update! temp_publication_status: issue.publication_status
      end

      Journal.find_each do |journal|
        journal.update! temp_publication_status: journal.publication_status
      end

      Logo.find_each do |logo|
        logo.update! temp_publication_status: logo.publication_status
      end

      Page.find_each do |page|
        page.update! temp_publication_status: page.publication_status
      end

      Poster.find_each do |poster|
        poster.update! temp_publication_status: poster.publication_status
      end

      Sticker.find_each do |sticker|
        sticker.update! temp_publication_status: sticker.publication_status
      end

      Video.find_each do |video|
        video.update! temp_publication_status: video.publication_status
      end

      Zine.find_each do |zine|
        zine.update! temp_publication_status: zine.publication_status
      end
    end
  end
end
# rubocop:enable Metrics/MethodLength
