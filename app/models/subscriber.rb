class Subscriber < ApplicationRecord
  before_save :clean_email

  def name
    email
  end

  private

  def clean_email
    self.email = self.email.strip.downcase
  end
end
