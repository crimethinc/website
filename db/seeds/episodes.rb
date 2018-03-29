require "nokogiri"

podcast = Podcast.find_by(title: "The Ex-Worker")

filepath = File.expand_path("../db/seeds/episodes/episodes.rss", __FILE__)
xml_doc  = File.open(filepath) { |f| Nokogiri::XML(f) }

xml_doc.css("item").reverse.each do |episode|
  title         = episode.css("title").text
  published_at  = Time.parse(episode.css("pubDate").text)
  image         = episode.css("image").attr("href")
  content       = episode.css("description").text
  audio_mp3_url = episode.css("enclosure").attr("url")
  audio_ogg_url = ""
  audio_length  = episode.css("enclosure").attr("length")
  tags          = episode.css("keywords").text
  duration      = episode.css("duration").text

  podcast.episodes.create!(
    title:         title,
    published_at:  published_at,
    image:         image,
    content:       content,
    audio_mp3_url: audio_mp3_url,
    audio_ogg_url: audio_ogg_url,
    audio_length:  audio_length,
    duration:      duration,
    tags:          tags
  )
end


filepath = File.expand_path("../db/seeds/episodes/episodes.html", __FILE__)
html_doc = File.open(filepath) { |f| Nokogiri::HTML(f) }

titles    = html_doc.css(".podmain h4").map(&:text)
subtitles = html_doc.css(".podmain h5").map(&:text)

title_and_subtitles = titles.zip(subtitles).to_h

title_and_subtitles.each do |title, subtitle|
  episode          = Episode.find(title.strip.match(/^#(\d+)/)[1])
  episode.subtitle = subtitle
  episode.save!
end


filepath = File.expand_path("../db/seeds/episodes/", __FILE__)

Dir.glob("#{filepath}/*").each do |f|
  filename = f.strip.split("/").last

  unless filename =~ /.DS_Store|episodes.rss|episodes.html|transcripts/
    doc = File.open(f) { |f| Nokogiri::HTML(f) }

    episode_id = doc.css("title").text.split("#").last.to_i
    list_items = doc.css(".podmain h2 + ul li")

    items = []
    list_items[2..-1].each do |item|
      items << item.to_s
    end

    download_info = list_items.first
    audio_mp3_url = download_info.css("a").first.attr("href")
    audio_ogg_url = download_info.css("a").last.attr("href")

    download_pieces     = download_info.text.match(/Download MP3 \((\d+) Min; (\d+)MB\), Download OGG \((\d+)MB\)/)
    duration            = download_pieces[1]
    audio_mp3_file_size = download_pieces[2]
    audio_ogg_file_size = download_pieces[3]

    episode                     = Episode.find(episode_id)
    episode.show_notes          = "<ul>#{items.join}</ul>"
    episode.audio_mp3_url       = audio_mp3_url
    episode.audio_ogg_url       = audio_ogg_url
    episode.duration            = duration
    episode.audio_mp3_file_size = audio_mp3_file_size
    episode.audio_ogg_file_size = audio_ogg_file_size
    episode.save!
  end
end


filepath = File.expand_path("../db/seeds/episodes/transcripts/", __FILE__)

Dir.glob("#{filepath}/*").each do |f|
  filename = f.strip.split("/").last

  unless filename =~ /.DS_Store/
    doc = File.open(f) { |f| Nokogiri::HTML(f) }

    episode_id = doc.css("title").text.split("#").last.to_i

    transcript = doc.css(".podmain")
    transcript.css("h4").first.remove
    transcript.css("h1").first.remove
    transcript.css("h4").first.remove

    episode            = Episode.find(episode_id)
    episode.transcript = transcript
    episode.save!
  end
end
