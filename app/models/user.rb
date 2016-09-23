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

  class << self
    def options_for_select
      User.all.map { |u| ["@#{u.username} (#{u.name})", u.id] }
    end
  end
end
