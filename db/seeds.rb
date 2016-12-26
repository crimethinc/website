%w(draft edited designed published).each do |status|
  Status.create!(name: status)
end


if Rails.env.development?
  test_user = User.new(
                username:              "tester",
                display_name:          "A Tester Account",
                email:                 "test@example.com",
                password:              "a long passphrase to meet the minimum length",
                password_confirmation: "a long passphrase to meet the minimum length")
  test_user.save!(validate: false)
end


# Seed post types on multiple threads
threads  = []

puts "Trying dev seeds for each post-type..."
%w(articles links podcasts episodes redirects).each do |posttype|
  filepath = File.expand_path("../seeds/#{posttype}.rb", __FILE__)

  puts "  Trying: #{posttype}"
  puts
  if File.exist?(filepath)
    puts "  Found: #{posttype}"
    eval(File.open(filepath).read)
    puts
    puts "...done"
    puts
  end
end

# Sync up post seeds threads before proceeding
threads.each { |t| t.join }
