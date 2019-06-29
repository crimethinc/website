test_user = User.new(username:              'tester',
                     password:              '123456789012345678901234567890',
                     password_confirmation: '123456789012345678901234567890')

test_user.save!(validate: false)

puts 'Trying dev seeds for each post-type...'
  # articles
  # books
  # episodes
%w[
  journals
  featured_journals
].each do |post_type|
  # pages
  # podcasts
  # redirects
  # videos
  file_path = File.expand_path("../seeds/#{post_type}.rb", __FILE__)

  puts "  Trying: #{post_type}"
  puts

  next unless File.exist?(file_path)

  puts "  Found: #{post_type}"
  eval(File.open(file_path).read)
  puts '...done'
  puts
end
