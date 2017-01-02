require "nokogiri"

# Clear out all testing Articles first
Article.destroy_all

# Find the "published" Status
published_status = Status.find_by(name: "published")



# These timestamps were pulled from the cwc.im admin site since
# the Feature HTML doesn't have any publishication datetime
features_timestamps          = {
  "agitators"                => Time.parse("2014-08-20 09:30:00 -0700"),
  "battle"                   => Time.parse("2016-11-01 09:19:00 -0700"),
  "begin"                    => Time.parse("2016-09-28 08:11:00 -0700"),
  "bluefuse"                 => Time.parse("2014-11-25 12:00:00 -0800"),
  "bosnia"                   => Time.parse("2016-05-13 09:10:00 -0700"),
  "demands"                  => Time.parse("2015-05-05 10:52:00 -0700"),
  "democracy"                => Time.parse("2012-04-29 12:20:00 -0700"),
  "destination"              => Time.parse("2016-04-07 09:49:00 -0700"),
  "digital-utopia"           => Time.parse("2013-10-04 06:45:00 -0700"),
  "empezar"                  => Time.parse("2016-09-28 08:10:00 -0700"),
  "ferguson"                 => Time.parse("2014-08-18 10:32:00 -0700"),
  "ferguson-reflections"     => Time.parse("2015-08-10 10:23:00 -0700"),
  "french911"                => Time.parse("2015-12-14 00:22:00 -0800"),
  "from-ferguson-to-the-bay" => Time.parse("2014-12-12 11:31:00 -0800"),
  "kobane"                   => Time.parse("2015-02-03 16:47:00 -0800"),
  "kurdish"                  => Time.parse("2015-09-23 14:07:00 -0700"),
  "next-time-it-explodes"    => Time.parse("2015-08-13 11:59:00 -0700"),
  "partys-over"              => Time.parse("2016-03-16 08:06:00 -0700"),
  "podemos"                  => Time.parse("2016-04-05 09:37:00 -0700"),
  "policemyths"              => Time.parse("2015-08-22 21:04:00 -0700"),
  "protect"                  => Time.parse("2015-11-17 01:52:00 -0800"),
  "reaction"                 => Time.parse("2016-10-24 09:10:00 -0700"),
  "slovenia"                 => Time.parse("2016-05-11 09:09:00 -0700"),
  "syriza"                   => Time.parse("2015-01-28 01:12:00 -0800"),
  "trump"                    => Time.parse("2016-12-13 12:45:00 -0800"),
  "ukraine"                  => Time.parse("2014-03-16 20:37:00 -0700"),
  "worldcupbrazil"           => Time.parse("2014-06-12 05:16:00 -0700"),
}


# Features as Articles
filepath = File.expand_path("../db/seeds/articles/features/", __FILE__)

# Create the Category for Features
category = Category.find_or_create_by name: "Features"

Dir.glob("#{filepath}/*/").each do |f|
  path_pieces = f.strip.split("/")
  filename    = path_pieces.last

  unless filename =~ /.DS_Store/
    doc   = File.open(f + "/index.html") { |f| Nokogiri::HTML(f) }

    slug         = path_pieces[-1]
    title        = doc.css("title").text.gsub(" / CrimethInc. Ex-Workers' Collective", "")
    subtitle     = ""

    title_pieces = title.split(":")
    if title_pieces.length > 1
      title        = title_pieces.first.strip
      subtitle     = title_pieces.last.strip
    end

    published_at = features_timestamps[slug]
    content      = File.read(f + "/index.html")
    image        = doc.css("meta[name='twitter:image:src']").attribute("content").value

    # Save the Article
    article = Article.create!(
      title:          title,
      subtitle:       subtitle,
      content:        content,
      published_at:   published_at,
      image:          image,
      status_id:      published_status.id,
      content_format: "html",
      hide_layout:    true
    )

    # Prefix slug with "feature-" to avoid collision with blog post with the same title on that day
    article.slug = "feature-#{article.slug}"
    article.save!

    # Add the Article to its Category and Theme
    category.articles << article

    # Redirect from old site Feature URLs to new site Article URLs
    if slug == "ukraine"
      namespace = "ux"
    elsif slug == "worldcupbrazil"
      namespace = "fx"
    elsif slug == "digital-utopia"
      namespace = "ex"
    else
      namespace = "r"
    end

    ["/texts/#{namespace}/#{slug}", "/texts/#{namespace}/#{slug}/", "/texts/#{namespace}/#{slug}/.index.html"].each do |source_path|
      Redirect.create! source_path: source_path, target_path: article.path, temporary: false
    end
 end
end



# Wordpress posts
filepath = File.expand_path("../db/seeds/articles/posts/", __FILE__)

Dir.glob("#{filepath}/*").each do |f|
  filename = f.strip.split("/").last

  unless filename =~ /.DS_Store/
    doc = File.open(f) { |f| Nokogiri::XML(f) }

    title   = doc.css("title").text
    content = doc.css("content_encoded").text

    # Published At timestamps
    published_at = Time.parse(doc.css("wp_post_date_gmt").text) # GMT
    published_at = Time.parse(doc.css("wp_post_date").text)     # PST # Seems to map to URLs more accurately

    # Old permalinks to support by creating Redirects to the new Article path
    redirect_paths = []
    redirect_paths << doc.css("link").text
    redirect_paths << doc.css("guid").text
    redirect_paths << "http://www.crimethinc.com/blog/?p=#{doc.css("wp_post_id").text}"

    # Short URL
    doc.css("wp_postmeta").each do |wp_postmeta|
      if wp_postmeta.css("wp_meta_key").text == "shorturl"
        redirect_paths << wp_postmeta.css("wp_meta_value").text
      end

      # Old permalinks to support by creating Redirects to the new Article path
      if wp_postmeta.css("wp_meta_key").text == "_wp_old_slug" && wp_postmeta.css("wp_meta_value").text.present?
        redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month}/#{published_at.day}/#{wp_postmeta.css("wp_meta_value").text}"
      end
    end

    # Remove duplicate Redirects
    redirect_paths = redirect_paths.uniq


    # Image and Header color
    image = ""
    header_background_color = ""
    doc.css("wp_postmeta").each do |wp_postmeta|
      if wp_postmeta.css("wp_meta_key").text == "jumbo"
        image = wp_postmeta.css("wp_meta_value").text
      end
    end

    if image.blank?
      header_background_color = "#444444"
    end

    # Find existing or create a new Contributor of words
    author_name = doc.css("dc_creator").text

    # Article slug
    slug = doc.css("wp_post_name").text

    # Category aka Desk
    category_name = doc.css("category[domain=category]").text

    # Save the Article
    article = Article.create!(
      title: title,
      content: content,
      published_at: published_at,
      slug: slug,
      header_background_color: header_background_color,
      image: image,
      status_id: published_status.id,
      content_format: "html"
    )

    # Add the Article to its Category and Theme
    category = Category.find_or_create_by name: category_name
    category.articles << article

    redirect_paths.each do |source_path|
      Redirect.create! source_path: source_path, target_path: article.path, temporary: false
    end
  end
end



# Site News Archive from pre- 3.0 of the site (pre Wordpress?)
filepath = File.expand_path("../db/seeds/articles/site-news-archive.html", __FILE__)
html_doc = File.open(filepath) { |f| Nokogiri::HTML(f) }

# And create a new Category for "Site News Archive"
category = Category.find_or_create_by! name: "Site News Archive"

# Find the "published" Status
published_status = Status.find_by(name: "published")

html_doc.css(".h-entry").each do |entry|
  title        = entry.css(".p-name").text

  published_at = Time.parse(entry.css(".dt-published").text)
  content      = entry.css(".e-content").inner_html
  content      = content.gsub("\n", "").gsub(/\s{2,}/, " ").gsub("<p>", "").gsub("</p>", "\n\n").gsub(" \n\n ", "\n\n")
  status_id    = published_status.id

  # Save the Article
  article = Article.create!(title:          title,
                            published_at:   published_at,
                            content:        content,
                            content_format: "html",
                            status_id:      status_id,
                            header_background_color: "#444")

  # Add the Article to its Category and Theme
  category.articles << article
end



# New feature style Articles
theme = Theme.create!(name: "Launch")

# Collect the articles together
articles = [
  {
    url: "http://www.crimethinc.com/texts/r/demands/",
    category: "Features",
    theme: theme,
    title: "Why We Don't Make Demands",
    image: "http://thecloud.crimethinc.com/assets/features/demands/images/header2560.jpg",
  },
  {
    url: "http://www.crimethinc.com/texts/r/democracy/",
    category: "Features",
    theme: theme,
    title: "From Democracy to Freedom",
    image: "http://thecloud.crimethinc.com/assets/features/democracy/images/header2000.jpg",
  },
  {
    url: "http://www.crimethinc.com/texts/r/kurdish/",
    category: "Features",
    theme: theme,
    title: "Understanding the Kurdish Resistance",
    subtitle: "Historical Overview & Eyewitness Report",
    image: "http://thecloud.crimethinc.com/assets/features/kurdish/images/header2000.jpg",
  },
  {
    url: "http://www.crimethinc.com/texts/r/next-time-it-explodes/",
    category: "Features",
    theme: theme,
    title: "Next Time It Explodes",
    subtitle: "Revolt, Repression, and Backlash since the Ferguson Uprising",
    image: "http://thecloud.crimethinc.com/assets/features/next-time-it-explodes/images/header2000.jpg",
  },
  {
    url: "http://www.crimethinc.com/texts/r/battle/",
    category: "Features",
    theme: theme,
    title: "Report Back from the Battle for Sacred Ground",
    image: "http://thecloud.crimethinc.com/assets/features/battle/images/header2000.jpg",
  }
]



# Find the "published" Status id once for reuse on each test Article
published_status = Status.find_by(name: "published")

# Loop through and create the articles
articles.each_with_index do |article_params, index|
  # Delete URL from params before creating Article
  article_params.delete(:url)

  # Delete Category from params before creating Article
  # And create a new Category
  category = Category.find_or_create_by! name: article_params.delete(:category)

  # Delete Theme from params before creating Article
  theme = article_params.delete(:theme)

  # Back date articles to the past 5 days for development
  days_offset  = index + 1
  published_at = Time.current - days_offset.days

  article_params[:published_at]   = published_at
  article_params[:status_id]      = published_status.id
  article_params[:content_format] = "html"

  # Save the Article
  article = Article.create!(article_params)

  # Find canonical Feature to Redirect to
  feature = Article.find_by(slug: "feature-#{article.slug}")
  article.content = "Redirect to Feature in feed: #{feature.path}"

  # Create Redirect
  Redirect.create source_path: article.path, target_path: feature.path, temporary: false

  # Add the Article to its Category and Theme
  category.articles << article
  if theme.present?
    theme.articles << article
  end
end




# Texts as Articles

# Find the "published" Status
published_status = Status.find_by(name: "published")

# Text collections
inside_front               = %w(permanentvacation selling situationists veganism workethic)
rolling_thunder            = %w(antinationalist demonstrating fineart greenscared insurrection irrepressible reallyreally rncdnc rncdncdocs rnclegal shac tenyear)
harbinger                  = %w(adultery beyonddemocracy definition divided h4intro indulge infighting manifesto72 onedimensional practical secretworld ultimatum warning)
days_of_war_nights_of_love = %w(alienation alive asfuck bourgeoisie concealment contents deadhand difference domestication forward invitation joinresistance nogods nomasters product reconsideringtv seduced shoplifting system taskforce69 unabomber washing)

filepath = File.expand_path("../db/seeds/articles/texts/texts/", __FILE__)

Dir.glob("#{filepath}/*").each do |f|
  path_pieces = f.strip.split("/")
  filename    = path_pieces.last

  unless filename =~ /.DS_Store/
    doc   = File.open(f) { |f| Nokogiri::HTML(f) }

    # Create the Category for Text
    filename_slug = filename.gsub(".php", "")

    # Set the right published_at date
    published_at_date = nil
    if %w(workethic selling situationists permanentvacation).include?(filename_slug)
      published_at_date = "January 1, 1996"
    elsif %w(practical).include?(filename_slug)
      published_at_date = "May 1, 1997"
    elsif %w(secretworld warning veganism adultery beyonddemocracy manifesto72 divided onedimensional ultimatum).include?(filename_slug)
      published_at_date = "September 11, 2000"
    elsif %w(h4intro indulge definition infighting).include?(filename_slug)
      published_at_date = "November 1, 2001"
    elsif %w(alienation alive asfuck bourgeoisie concealment contents deadhand difference domestication forward invitation joinresistance nogods nomasters product reconsideringtv seduced shoplifting system taskforce69 unabomber washing).include?(filename_slug)
      published_at_date = "September 11, 2000"
    else
      published_at_date = "September 11, 1900"
    end
    published_at = Time.parse(published_at_date)

    # Set the right Category
    if inside_front.include?(filename_slug)
      category_name = "Inside Front"
    elsif rolling_thunder.include?(filename_slug)
      category_name = "Rolling Thunder"
    elsif harbinger.include?(filename_slug)
      category_name = "Harbinger"
    elsif days_of_war_nights_of_love.include?(filename_slug)
      category_name = "Days of War, Nights of Love"
    else
      category_name = "Texts"
    end
    category = Category.find_or_create_by name: category_name


    title                   = doc.css("h1").first.try(:text)
    subtitle                = nil
    content                 = File.read(f)
    image                   = nil
    header_background_color = "#444444"

    # Save the Article
    article = Article.create!(
      title:          title || filename_slug,
      subtitle:       subtitle,
      content:        content,
      published_at:   published_at,
      image:          image,
      status_id:      published_status.id,
      content_format: "html",
      hide_layout:    false,
      header_background_color: header_background_color
    )

    # Add the Article to its Category and Theme
    category.articles << article

    # TODO
    # ["/texts/#{namespace}/#{slug}", "/texts/#{namespace}/#{slug}/", "/texts/#{namespace}/#{slug}/.index.html"].each do |source_path|
    #   Redirect.create! source_path: source_path, target_path: article.path, temporary: false
    # end
  end
end
