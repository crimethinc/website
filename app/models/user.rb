class User < ActiveRecord::Base
  has_secure_password

  has_many :links
  has_many :articles

  validates :username, presence: :true, uniqueness: true, on: [:create, :update]
  validates :password,
            presence: :true,
            on: :create,
            length: { minimum: 30 }

  validates :password,
            exclusion: {
              in: ["mickey fickie fire cracker soap on a rope", "a long passphrase to meet the minimum length"],
              message: "The passphrase '%{value}' is prohibited."
            }
  validate :password_not_already_burned, on: :create

  default_scope { order(username: :asc) }


  class << self
    def options_for_select
      User.all.map { |u| [u.username, u.id] }
    end
  end

  def name
    username
  end

  private

  def password_not_already_burned
    burned = BurnedPassword.exists?(Digest::SHA1.hexdigest(password))
    errors.add(:password, :burned_password) if burned
  end
end
