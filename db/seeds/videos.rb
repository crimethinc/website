require 'nokogiri'
# TODO: add TCE video
# TODO add Vimeo videos

# Videos
file_path = File.expand_path('db/seeds/videos', __dir__)

Dir.glob("#{file_path}/*").each do |file|
  path_pieces = file.strip.split('/')
  file_name   = path_pieces.last

  next if /.DS_Store/.match?(file_name)

  doc = File.open(file) { |f| Nokogiri::HTML(f) }

  title        = doc.css('.title').text
  slug         = title.to_slug

  info_pieces = doc.css('.info').text
  quality, _year, duration = info_pieces.split(' / ')

  content      = doc.css('.desc').inner_html.gsub(/\s+/, ' ')
  vimeo_id     = doc.css('iframe').attribute('src').value.match(%r{video/(\d+)})[1]

  # Save the Video
  Video.create!(
    title:              title,
    subtitle:           nil,
    content:            content,
    tweet:              nil,
    summary:            nil,
    slug:               slug,
    quality:            quality,
    duration:           duration,
    vimeo_id:           vimeo_id,
    content_format:     'html',
    publication_status: 'published',
    published_at:       1.year.ago
  )

  puts "videos/#{file_name}"
  puts "videos/#{slug}"
  puts

  Redirect.create! source_path: "movies/#{file_name}", target_path: "videos/#{slug}", temporary: false unless Redirect.find_by(source_path: "/movies/#{file_name}").present?
end

Redirect.create! source_path: 'movies', target_path: 'watch', temporary: false unless Redirect.find_by(source_path: '/movies').present?
