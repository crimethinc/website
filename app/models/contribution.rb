class Contribution < ApplicationRecord
  belongs_to :article
  belongs_to :contributor
  belongs_to :role
end
