class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :article
end
