class Redirect < ApplicationRecord
  validates :source_path, presence: true, uniqueness: true
  validates :target_path, presence: true
  # validate :article_short_path_unique

  validate :noncircular_redirect

  before_save :strip_leading_domain,    on: [:create, :update]
  before_save :add_leading_slash,       on: [:create, :update]

  after_save :delete_duplicates,        on: [:create, :update]

  def name
    "#{source_path} to #{target_path}"
  end

  def add_leading_slash
    unless self.source_path =~ /^\/|http/
      self.source_path = "/#{self.source_path}"
    end

    unless self.target_path =~ /^\/|http/
      self.target_path = "/#{self.target_path}"
    end
  end

  def strip_leading_domain
    domains_regex = /crimethinc|cwc\.im/

    [self.source_path, self.target_path].each_with_index do |path, index|
      url = URI.parse(path.strip)
      if url.respond_to?(:host) && url.host =~ domains_regex
        new_path = url.path

        if url.query.present?
          new_path << "?#{url.query}"
        end

        if url.fragment.present?
          new_path << "##{url.fragment}"
        end

        if index.zero?
          self.source_path = new_path
        else
          self.target_path = new_path
        end
      end
    end

  end

  private

  def delete_duplicates
    previous_redirect = Redirect.where(source_path: self.source_path, target_path: self.target_path).where.not(id: self.id)
    if previous_redirect.present?
      self.destroy
    end
  end

  def noncircular_redirect
    errors.add(:target_path, "redirects to itself") if source_path == target_path
  end

  def article_short_path_unique
    errors.add(:source_path, 'is already taken by article short path') if Article.where(short_path: self.source_path[/\w+/]).exists?
  end

end
