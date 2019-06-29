test_user = User.new(username:              'tester',
                     password:              '123456789012345678901234567890',
                     password_confirmation: '123456789012345678901234567890')

test_user.save!(validate: false)

puts 'Trying dev seeds for each post-type...'
# journals
# featured_journals
# pages
# videos
# books
%w[
  podcasts
].each do |post_type|
  # episodes
  # redirects
  # articles
  file_path = File.expand_path("../seeds/#{post_type}.rb", __FILE__)

  puts "  Trying: #{post_type}"
  puts

  next unless File.exist?(file_path)

  puts "  Found: #{post_type}"
  eval(File.open(file_path).read)
  puts '...done'
  puts
end
