puts '==> Downloading DB dump from S3…'
sh 'rails db:dump:download'
puts

puts '==> Importing pg dump into local development DB…'
sh 'rails db:dump:import'
puts

puts '==> All done!'
