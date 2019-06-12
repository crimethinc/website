# Start your Rails server with this ENV var:
#     TWO_POINT_OH_YEAH=true bundle exec rails server
#
# Use the FeatureFlag checker like this:
#     FeatureFlag.enabled? :two_point_oh_yeah

class FeatureFlag
  class << self
    def enabled? feature
      env_var = ENV.fetch(feature.to_s.upcase) { false }
      env_var == true.to_s
    end
  end
end
