desc 'Request the Wayback Machine to snapshot a ALL articles'
task :wayback_all, [:url] => :environment do |_t, _args|
  WaybackMachineArchiver.new.run
end
