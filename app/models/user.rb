class User < ApplicationRecord
  has_secure_password

  PASSWORD_MINIMUM_LENGTH = 30
  ROLES = %i[author editor publisher].freeze

  enum role: ROLES

  validates :username, presence: true, uniqueness: true, on: %i[create update]

  validates :password,
            presence:  true,
            on:        :create,
            length:    { minimum: PASSWORD_MINIMUM_LENGTH },
            exclusion: {
              in:      [
                'mickey fickie fire cracker soap on a rope',
                'a long passphrase to meet the minimum length'
              ],
              message: 'The passphrase ‘%{value}’ is prohibited.'
            }

  default_scope { order(username: :asc) }

  before_validation :strip_whitespace, on: %i[create update]

  def name
    username
  end

  def strip_whitespace
    self.username = username.strip
  end

  def default_role!
    @user.author!
  end

  # All of the publisher only permissions
  alias can_admin_users? publisher?
  alias can_publish?     publisher?
  alias can_delete?      publisher?

  def cant_publish?
    !can_publish?
  end
end
