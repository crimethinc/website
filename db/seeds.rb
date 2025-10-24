# rubocop:disable Rails/Output
puts '==> Downloading DB dump from S3…'
sh 'rake db:import:download'
puts

puts '==> Importing pg dump into local development DB…'
sh 'rake db:import:populate'
puts

puts '==> Importing uploads into local development DB…'
sh 'rake seed:uploads:import'
puts

puts '==> All done!'
# rubocop:enable Rails/Output
