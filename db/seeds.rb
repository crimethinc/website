puts '==> Downloading DB dump from S3…'
sh 'rake db:import:download'
puts

puts '==> Importing pg dump into local development DB…'
sh 'rake db:import:populate'
puts

puts '==> All done!'
