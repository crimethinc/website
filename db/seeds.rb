puts '==> Downloading DB dump from S3…'
sh 'rake db:dump:download'
puts

puts '==> Importing pg dump into local development DB…'
sh 'rake db:dump:import'
puts

puts '==> All done!'
