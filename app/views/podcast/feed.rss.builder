xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.rss 'version'      => '2.0',
        'xmlns:atom'   => 'http://www.w3.org/2005/Atom',
        'xmlns:cc'     => 'http://web.resource.org/cc/',
        'xmlns:itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd',
        'xmlns:media'  => 'http://search.yahoo.com/mrss/',
        'xmlns:rdf'    => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#' do

  xml.channel do
    xml.tag!('atom:link', href: podcast_feed_url, rel: 'self', type: 'application/rss+xml')
    xml.title @podcast.title
    xml.pubDate @episodes.first.published_at.to_s(:rfc822)
    xml.lastBuildDate @episodes.first.published_at.to_s(:rfc822)
    xml.link podcast_url
    xml.language @podcast.language

    xml.copyright do
      xml.cdata! @podcast.copyright
    end

    xml.docs podcast_url
    xml.managingEditor "#{@podcast.itunes_owner_email} (#{@podcast.itunes_owner_email})"

    xml.tag!('itunes:summary') do
      xml.cdata! @podcast.itunes_summary
    end

    xml.image do
      xml.url @podcast.image
      xml.title @podcast.title
      xml.link do
        xml.cdata! podcast_url
      end
    end

    xml.tag!('itunes:author') do
      xml.text! @podcast.itunes_author
    end

    xml.tag!('itunes:keywords') do
      xml.text! @podcast.tags
    end

    # TODO: These are hardcoded for now.  Find a simple way to nest categories.
    xml.tag!('itunes:category', text: 'News & Politics')
    xml.tag!('itunes:category', text: 'Society & Culture') do
      xml.tag!('itunes:category', text: 'Philosophy')
    end
    xml.tag!('itunes:category', text: 'Arts')

    xml.tag!('itunes:image', href: @podcast.image)

    xml.tag!('itunes:explicit') do
      xml.text! @podcast.itunes_explicit? ? 'yes' : 'no'
    end

    xml.tag!('itunes:owner') do
      xml.tag!('itunes:name') do
        xml.cdata! @podcast.itunes_owner_name
      end
      xml.tag!('itunes:email') do
        xml.text! @podcast.itunes_owner_email
      end
    end

    xml.description do
      xml.cdata! @podcast.meta_description
    end

    xml.tag!('itunes:subtitle') do
      xml.cdata! @podcast.subtitle
    end

    @episodes.each do |episode|
      xml.item do
        xml.title episode.title
        xml.pubDate episode.published_at.to_s(:rfc822)

        xml.guid(isPermalink: false) do
          xml.text! episode.id.to_s
        end

        xml.link do
          xml.cdata! episode_url(episode)
        end

        xml.tag!('itunes:image', href: episode.image)

        xml.description do
          xml.cdata! episode.content +
                     ' <p> </p> <p> </p> <p>-------SHOW NOTES------</p> <p> </p> ' +
                     episode.show_notes
        end

        xml.enclosure(length: episode.audio_length, type: episode.audio_type, url: episode.audio_mp3_url)

        xml.tag!('itunes:duration') do
          xml.text! episode.duration_string
        end

        xml.tag!('itunes:explicit') do
          xml.text! @podcast.itunes_explicit? ? 'yes' : 'no'
        end

        xml.tag!('itunes:subtitle') do
          xml.cdata! truncate(html_doc = Nokogiri::HTML(episode.content).text, length: 245)
        end
      end
    end
  end
end
