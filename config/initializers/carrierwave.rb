# TODO: what happens if the ENVs are missing?
# TODO: is ENV safe way to handle these credentials?
if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end

# TODO: staging too?
if Rails.env.prod?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.enable_processing = true

    # required settings
    config.fog_provider = 'fog/aws'
    config.fog_directory  = 'article-header-images'

    # optional settings
    config.fog_public     = true # defaults to true
    config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # defaults to {}

    config.fog_credentials = {
      # required credentials
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_CARRIERWAVE_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_CARRIERWAVE_ACCESS_KEY'],

      # optional values
      region:     'us-west-2', # defaults to 'us-east-1'
      # host:     's3.example.com',             # defaults to nil
      # endpoint: 'https://s3.example.com:8080' # defaults to nil
    }
    config.asset_host = "https://cloudfront.crimethinc.com"
  end
end
