class Redirect < ApplicationRecord
  before_validation :strip_leading_domain_from_source_path, on: [:create, :update]
  before_validation :strip_leading_domain_from_target_path, on: [:create, :update]
  before_validation :add_leading_slash,                     on: [:create, :update]

  validates :source_path, presence: true, uniqueness: true
  validates :target_path, presence: true
  validate  :article_short_path_unique

  validate :noncircular_redirect

  def name
    source_path
  end

  def add_leading_slash
    unless self.source_path =~ /^\/|http/
      self.source_path = "/#{self.source_path}"
    end

    unless self.target_path =~ /^\/|http/
      self.target_path = "/#{self.target_path}"
    end
  end

  def strip_leading_domain_from_source_path
    domains_regex = /crimethinc|cwc\.im/

    path = self.source_path.strip
    path = path.gsub(/http:\/\//, "")
    path = path.gsub(/https:\/\//, "")
    path = "http://" + path

    url = URI.parse(path)
    if url.respond_to?(:host) && url.host =~ domains_regex
      new_path = url.path

      if url.query.present?
        new_path << "?#{url.query}"
      end

      if url.fragment.present?
        new_path << "##{url.fragment}"
      end

      self.source_path = new_path
    end
  end

  def strip_leading_domain_from_target_path
    domains_regex = /crimethinc|cwc\.im/

    path = self.target_path.strip
    path = path.gsub(/http:\/\//, "")
    path = path.gsub(/https:\/\//, "")
    path = "http://" + path

    url = URI.parse(path)
    if url.respond_to?(:host) && url.host =~ domains_regex
      new_path = url.path

      if url.query.present?
        new_path << "?#{url.query}"
      end

      if url.fragment.present?
        new_path << "##{url.fragment}"
      end

      self.target_path = new_path
    end
  end

  private

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
