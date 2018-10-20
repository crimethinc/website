HoneycombRails.configure do |conf|
  conf.writekey   = ENV['HONEYCOMB_WRITEKEY']
  conf.dataset    = ENV['HONEYCOMB_DATASET']
  conf.db_dataset = ENV['HONEYCOMB_DB_DATASET']
end
