desc 'Request the Wayback Machine to snapshot a specific URL or all new ' \
     'article URLs for the past 24 hours if no argument is given'
task :wayback, [:url] => :environment do |_t, args|
  url = args[:url]
  WaybackMachineArchiver.new(url: url).run
end
