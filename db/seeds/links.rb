# Clear out all testing Links first
Link.destroy_all

# Collect the links together
links = {
  "CrimethInc. on Twitter"        => "https://twitter.com/crimethinc",
  "CrimethincDotCom on Facebook"  => "https://facebook.com/CrimethincDotCom",
  "CrimethincDotCom on Instagram" => "https://instagram.com/CrimethincDotCom",
  "Crimethinc. on Medium"         => "https://medium.com/@crimethinc",
  "CrimethInc. on Tumblr"         => "http://crimethincdotcom.tumblr.com",
  "CrimethInc. on Wordpress"      => "https://crimethincdotcom.wordpress.com",
  "CrimethInc. on Vimeo"          => "https://vimeo.com/crimethinc",
  "CrimethInc. on Youtube"        => "https://www.youtube.com/channel/UCH9VbQUhFVjTyUZhZqDVlDw",
  "Crimethinc on Periscope"       => "https://www.periscope.tv/crimethinc",
  "CrimethInc. on Snapchat"       => "https://www.snapchat.com/add/crimethinc",
}

links.each do |name, url|
  Link.create!(name: name, url: url)
end
