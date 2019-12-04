class Redirect < ApplicationRecord
  before_validation :strip_blank_space,             on: %i[create update]
  before_validation :strip_domain_from_source_path, on: %i[create update]
  before_validation :strip_domain_from_target_path, on: %i[create update]
  before_validation :add_leading_slash,             on: %i[create update]
  before_validation :strip_double_slashes,          on: %i[create update]
  before_validation :downcase_source_path,          on: %i[create update]

  validates :source_path, presence: true, uniqueness: true
  validates :target_path, presence: true
  validate  :article_short_path_unique
  validate  :noncircular_redirect

  default_scope { order(source_path: :asc) }

  def name
    source_path
  end

  def strip_blank_space
    self.source_path = source_path.strip
    self.target_path = target_path.strip
  end

  def add_leading_slash
    paths.each do |path|
      path.prepend '/' unless path.starts_with?('/') || path.starts_with?('http')
    end
  end

  def strip_double_slashes
    paths.each do |path|
      path.downcase.gsub!('//', '/')
    end
  end

  def downcase_source_path
    source_path.downcase!
  end

  def strip_domain_from_path path
    url = build_url_for path
    groomed_path_or_url url if url.respond_to? :host
  end

  def strip_domain_from_source_path
    self.source_path = strip_domain_from_path source_path
  end

  def strip_domain_from_target_path
    self.target_path = strip_domain_from_path target_path
  end

  private

  def paths
    [source_path, target_path]
  end

  def build_url_for path
    URI.parse path
  end

  def groomed_path_or_url url
    url_pieces = []
    url_pieces << "#{url.scheme}://#{url.host}" unless url.host.blank? || crimethinc_apex_domain_url?(url)
    url_pieces << url.path
    url_pieces << '?' + url.query    if url.query.present?
    url_pieces << '#' + url.fragment if url.fragment.present?
    url_pieces.join
  end

  def crimethinc_apex_domain_url? url
    %w[
      crimethinc.com
      www.crimethinc.com
      cwc.im
      www.cwc.im
    ].include? url.host
  end

  def noncircular_redirect
    errors.add(:target_path, I18n.t('activerecord.errors.models.article.target_path.uniqueness')) if source_path == target_path
  end

  def article_short_path_unique
    aa = Article.where(short_path: source_path[/\w+/])

    return if aa.blank?

    errors.add(:source_path, I18n.t('activerecord.errors.models.article.source_path.uniqueness')) unless aa.first.id == article_id
  end
end
