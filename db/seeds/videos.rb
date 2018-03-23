require "nokogiri"


# TODO add TCE video
# TODO add Vimeo videos


# Videos
filepath = File.expand_path("../db/seeds/videos/", __FILE__)

Dir.glob("#{filepath}/*").each do |form|
  path_pieces = form.strip.split("/")
  filename    = path_pieces.last

  unless filename =~ /.DS_Store/
    doc   = File.open(form) { |form| Nokogiri::HTML(form) }

    title        = doc.css(".title").text
    slug         = title.to_slug

    info_pieces = doc.css(".info").text
    quality, year, duration = info_pieces.split(" / ")

    published_at = year
    content      = doc.css(".desc").inner_html.gsub(/\s+/, " ")
    vimeo_id     = doc.css("iframe").attribute("src").value.match(/video\/(\d+)/)[1]

    # Save the Video
    video = Video.create!(
      title:          title,
      subtitle:       nil,
      content:        content,
      tweet:          nil,
      summary:        nil,
      slug:           slug,
      quality:        quality,
      duration:       duration,
      vimeo_id:       vimeo_id,
      published_at:   published_at,
      content_format: "html"
    )

    puts "movies/#{filename}"
    puts "movies/#{slug}"
    puts

    unless Redirect.find_by(source_path: "/movies/#{filename}").present?
      Redirect.create! source_path: "movies/#{filename}", target_path: "movies/#{slug}", temporary: false
    end
 end

end

unless Redirect.find_by(source_path: "/movies").present?
  Redirect.create! source_path: "movies", target_path: "watch", temporary: false
end
