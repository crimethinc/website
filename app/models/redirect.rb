class Redirect < ApplicationRecord
  before_validation :add_leading_slash, on: [:create, :update]

  def name
    "#{source_path} to #{target_path}"
  end

  def add_leading_slash
    unless self.source_path =~ /^\//
      self.source_path = "/#{self.source_path}"
    end

    unless self.target_path =~ /^\//
      self.target_path = "/#{self.target_path}"
    end
  end
end
