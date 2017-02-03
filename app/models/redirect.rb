class Redirect < ApplicationRecord
  validates :source_path, presence: true, uniqueness: true
  validates :target_path, presence: true

  before_save :strip_leading_domain,    on: [:create, :update]
  before_save :add_leading_slash,       on: [:create, :update]

  after_save :delete_duplicates,        on: [:create, :update]
  after_save :delete_cirular_redirects, on: [:create, :update]

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
    url = URI.parse(self.target_path)
    if url.respond_to?(:host) && url.host =~ /crimethinc|cwc\.im/
      path = url.path

      if url.query.present?
        path << "?#{url.query}"
      end

      self.target_path = path
    end
  end

  private

  def delete_duplicates
    previous_redirect = Redirect.where(source_path: self.source_path, target_path: self.target_path).where.not(id: self.id)
    if previous_redirect.present?
      self.destroy
    end
  end

  def delete_cirular_redirects
    redirects = Redirect.where(source_path: self.source_path, target_path: self.source_path)
    if redirects.present?
      redirects.destroy_all
    end

    redirects = Redirect.where(source_path: self.target_path, target_path: self.target_path)
    if redirects.present?
      redirects.destroy_all
    end
  end

end
