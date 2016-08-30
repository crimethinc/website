class User < ActiveRecord::Base
  has_secure_password
  validates :password, presence: :true, on: :create
  validates :email,    presence: :true, uniqueness: true, on: [:create, :update]
end
