class Categorization < ApplicationRecord
  belongs_to :category
  belongs_to :article, touch: true
end
