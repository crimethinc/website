class BurnedPassword < ActiveRecord::Base
  self.primary_key = 'password_sha1'
end
