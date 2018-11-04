test_user = User.new(
              username:              'tester',
              password:              '123456789012345678901234567890',
              password_confirmation: '123456789012345678901234567890')
test_user.save!(validate: false)

puts 'Trying dev seeds for each post-type...'
%w[articles books pages podcasts episodes redirects videos journals featured_journals].each do |posttype|
  filepath = File.expand_path("../seeds/#{posttype}.rb", __FILE__)

  puts "  Trying: #{posttype}"
  puts
  if File.exist?(filepath)
    puts "  Found: #{posttype}"
    eval(File.open(filepath).read)
    puts "...done"
    puts
  end
end
