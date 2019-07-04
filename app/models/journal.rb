class Journal < ApplicationRecord
  has_many :issues, dependent: :destroy
end
