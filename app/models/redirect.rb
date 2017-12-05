class Redirect < ApplicationRecord
  before_validation :strip_leading_domain_from_source_path, on: [:create, :update]
  before_validation :strip_leading_domain_from_target_path, on: [:create, :update]
  before_validation :add_leading_slash,                     on: [:create, :update]
  before_validation :strip_double_slashes,                  on: [:create, :update]

  validates :source_path, presence: true, uniqueness: true
  validates :target_path, presence: true
  validate  :article_short_path_unique
  validate  :noncircular_redirect

  def name
    source_path
  end

  def add_leading_slash
    [self.source_path, self.target_path].each do |path_type|
      path_type.prepend "/" unless path_type =~ %r{^/|http}
    end
  end

  def strip_double_slashes
    [self.source_path, self.target_path].each do |path_type|
      path_type.gsub!("//", "/")
    end
  end

  def strip_leading_domain_from_path path_type
    url = build_url_for path_type
    groomed_path_or_url url if url.respond_to? :host
  end

  def strip_leading_domain_from_source_path
    self.source_path = strip_leading_domain_from_path self.source_path
  end

  def strip_leading_domain_from_target_path
    self.target_path = strip_leading_domain_from_path self.target_path
  end

  private

  def build_url_for path_type
    URI.parse("http://" + strip_protocol_from_path(path_type))
  end

  def strip_protocol_from_path path_type
    path_type.strip.gsub(%r{https*://}, "")
  end

  def groomed_path_or_url url
    url_pieces = []
    url_pieces << url.host unless url.host =~ %r{crimethinc.com|cwc.im}
    url_pieces << url.path
    url_pieces << "?" + url.query    if url.query.present?
    url_pieces << "#" + url.fragment if url.fragment.present?
    url_pieces.join
  end

  def noncircular_redirect
    errors.add(:target_path, "redirects to itself") if source_path == target_path
  end

  def article_short_path_unique
    aa = Article.where(short_path: self.source_path[/\w+/])

    if aa.exists?
      unless aa.first.id == self.article_id
        errors.add(:source_path, "is already taken by article short path")
      end
    end
  end
end
