class Redirect < ApplicationRecord
  validates :source_path, presence: true
  validates :target_path, presence: true

  before_save :strip_leading_domain, on: [:create, :update]
  before_save :add_leading_slash,    on: [:create, :update]

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
end
