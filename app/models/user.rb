class User < ApplicationRecord
  has_secure_password

  PASSWORD_MINIMUM_LENGTH = 30

  validates :username, presence: true, uniqueness: true, on: [:create, :update]
  validates :password,
            presence: true,
            on: :create,
            length: { minimum: PASSWORD_MINIMUM_LENGTH }

  validates :password,
            exclusion: {
              in: ['mickey fickie fire cracker soap on a rope', 'a long passphrase to meet the minimum length'],
              message: 'The passphrase ‘%{value}’ is prohibited.'
            }

  default_scope { order(username: :asc) }

  class << self
    def options_for_select
      all.map { |u| [u.username, u.id] }
    end
  end

  def name
    username
  end
end
