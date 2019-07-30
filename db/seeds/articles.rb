require 'nokogiri'

# Clear out all testing Articles first
Article.destroy_all

# These timestamps were pulled from the cwc.im admin site since
# the Feature HTML doesn't have any publishication datetime
features_timestamps          = {
  'agitators'                => Time.parse('2014-08-20 09:30:00 -0700'),
  'battle'                   => Time.parse('2016-11-01 09:19:00 -0700'),
  'begin'                    => Time.parse('2016-09-28 08:11:00 -0700'),
  'bluefuse'                 => Time.parse('2014-11-25 12:00:00 -0800'),
  'bosnia'                   => Time.parse('2016-05-13 09:10:00 -0700'),
  'demands'                  => Time.parse('2015-05-05 10:52:00 -0700'),
  'democracy'                => Time.parse('2012-04-29 12:20:00 -0700'),
  'destination'              => Time.parse('2016-04-07 09:49:00 -0700'),
  'digital-utopia'           => Time.parse('2013-10-04 06:45:00 -0700'),
  'empezar'                  => Time.parse('2016-09-28 08:10:00 -0700'),
  'ferguson'                 => Time.parse('2014-08-18 10:32:00 -0700'),
  'ferguson-reflections'     => Time.parse('2015-08-10 10:23:00 -0700'),
  'french911'                => Time.parse('2015-12-14 00:22:00 -0800'),
  'from-ferguson-to-the-bay' => Time.parse('2014-12-12 11:31:00 -0800'),
  'kobane'                   => Time.parse('2015-02-03 16:47:00 -0800'),
  'kurdish'                  => Time.parse('2015-09-23 14:07:00 -0700'),
  'next-time-it-explodes'    => Time.parse('2015-08-13 11:59:00 -0700'),
  'partys-over'              => Time.parse('2016-03-16 08:06:00 -0700'),
  'podemos'                  => Time.parse('2016-04-05 09:37:00 -0700'),
  'policemyths'              => Time.parse('2015-08-22 21:04:00 -0700'),
  'protect'                  => Time.parse('2015-11-17 01:52:00 -0800'),
  'reaction'                 => Time.parse('2016-10-24 09:10:00 -0700'),
  'slovenia'                 => Time.parse('2016-05-11 09:09:00 -0700'),
  'syriza'                   => Time.parse('2015-01-28 01:12:00 -0800'),
  'trump'                    => Time.parse('2016-12-13 12:45:00 -0800'),
  'ukraine'                  => Time.parse('2014-03-16 20:37:00 -0700'),
  'worldcupbrazil'           => Time.parse('2014-06-12 05:16:00 -0700')
}

# Features as Articles
file_path = File.expand_path('db/seeds/articles/features', __dir__)

# Create the Category for Features
category = Category.find_or_create_by name: 'Features'

Dir.glob("#{file_path}/*/").each do |file|
  path_pieces = file.strip.split('/')
  file_name = path_pieces.last

  next if /.DS_Store/.match?(file_name)

  doc = File.open(file + '/index.html') { |f| Nokogiri::HTML(f) }

  slug         = path_pieces[-1]
  title        = doc.css('title').text.gsub("' / CrimethInc. Ex-Workers' Collective", '')
  subtitle     = ''

  title_pieces = title.split(':')
  if title_pieces.length > 1
    title        = title_pieces.first.strip
    subtitle     = title_pieces.last.strip
  end

  published_at = features_timestamps[slug]
  content      = File.read(file + '/index.html')
  image        = begin
                     doc.css("meta[name='twitter:image:src']").attribute('content').value
                 rescue StandardError
                   nil
                   end

  # Save the Article
  article = Article.create!(
    title:              title,
    subtitle:           subtitle,
    content:            content,
    published_at:       published_at,
    image:              image,
    publication_status: 'published',
    content_format:     'html',
    short_path:         SecureRandom.hex
  )

  # Prefix slug with "feature-" to avoid collision with blog post with the same title on that day
  article.slug = "feature-#{article.slug}"
  article.save!

  # Add the Article to its Category
  category.articles << article

  # Redirect from old site Feature URLs to new site Article URLs
  namespace = if slug == 'ukraine'
                'ux'
              elsif slug == 'worldcupbrazil'
                'fx'
              elsif slug == 'digital-utopia'
                'ex'
              else
                'r'
              end

  [
    "/texts/#{namespace}/#{slug}",
    "/texts/#{namespace}/#{slug}/",
    "/texts/#{namespace}/#{slug}/index.html",
    "/texts/#{namespace}/#{slug}.html"
  ].each do |source_path|
    # Redirect.create! source_path: source_path, target_path: article.path, temporary: false
    # puts "#{source_path} #{article.path}"
  end
end

# Wordpress posts
file_path = File.expand_path('db/seeds/articles/posts', __dir__)

Dir.glob("#{file_path}/*").each do |file|
  file_name = file.strip.split('/').last

  next if /.DS_Store/.match?(file_name)

  doc = File.open(file) { |f| Nokogiri::XML(f) }

  title   = doc.css('title').text
  content = doc.css('content_encoded').text

  # Published At timestamps
  published_at = Time.parse(doc.css('wp_post_date_gmt').text) # GMT
  published_at = Time.parse(doc.css('wp_post_date').text)     # PST # Seems to map to URLs more accurately

  # Wordpress post slug
  slug = doc.css('guid').text.split('/').compact.last

  # Old permalinks to support by creating Redirects to the new Article path
  redirect_paths = []
  redirect_paths << doc.css('link').text
  redirect_paths << doc.css('guid').text
  redirect_paths << "http://www.crimethinc.com/blog/?p=#{doc.css('wp_post_id').text}"
  redirect_paths << "http://www.crimethinc.com/blog?p=#{doc.css('wp_post_id').text}"

  # Redirects for leading and non-leading zero months and days
  redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month}/#{published_at.day}/#{slug}"
  redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month.to_s.sub(/^0/, '')}/#{published_at.day}/#{slug}"
  redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month}/#{published_at.day.to_s.sub(/^0/, '')}/#{slug}"
  redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month.to_s.sub(/^0/, '')}/#{published_at.day.to_s.sub(/^0/, '')}/#{slug}"
  redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month.to_s.rjust(2, '0')}/#{published_at.day}/#{slug}"
  redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month}/#{published_at.day.to_s.rjust(2, '0')}/#{slug}"
  redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month.to_s.rjust(2, '0')}/#{published_at.day.to_s.rjust(2, '0')}/#{slug}"

  # Short URL
  doc.css('wp_postmeta').each do |wp_postmeta|
    redirect_paths << wp_postmeta.css('wp_meta_value').text if wp_postmeta.css('wp_meta_key').text == 'shorturl'

    # Old permalinks to support by creating Redirects to the new Article path
    next unless wp_postmeta.css('wp_meta_key').text == '_wp_old_slug' && wp_postmeta.css('wp_meta_value').text.present?

    redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month}/#{published_at.day}/#{wp_postmeta.css('wp_meta_value').text}"
    redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month.to_s.sub(/^0/, '')}/#{published_at.day}/#{wp_postmeta.css('wp_meta_value').text}"
    redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month}/#{published_at.day.to_s.sub(/^0/, '')}/#{wp_postmeta.css('wp_meta_value').text}"
    redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month.to_s.sub(/^0/, '')}/#{published_at.day.to_s.sub(/^0/, '')}/#{wp_postmeta.css('wp_meta_value').text}"
    redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month.to_s.rjust(2, '0')}/#{published_at.day}/#{wp_postmeta.css('wp_meta_value').text}"
    redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month}/#{published_at.day.to_s.rjust(2, '0')}/#{wp_postmeta.css('wp_meta_value').text}"
    redirect_paths << "http://www.crimethinc.com/blog/#{published_at.year}/#{published_at.month.to_s.rjust(2, '0')}/#{published_at.day.to_s.rjust(2, '0')}/#{wp_postmeta.css('wp_meta_value').text}"
  end

  # Image
  image = ''
  doc.css('wp_postmeta').each do |wp_postmeta|
    image = wp_postmeta.css('wp_meta_value').text if wp_postmeta.css('wp_meta_key').text == 'jumbo'
  end

  # Article slug
  slug = doc.css('wp_post_name').text

  # Category aka Desk
  category_name = doc.css('category[domain=category]').text

  # Save the Article
  article = Article.create!(
    title:              title,
    content:            content,
    published_at:       published_at,
    slug:               slug,
    image:              image,
    publication_status: 'published',
    content_format:     'html',
    short_path:         SecureRandom.hex
  )

  # Add the Article to its Category
  category = Category.find_or_create_by name: category_name
  category.articles << article

  # Remove duplicate Redirects
  redirect_paths = redirect_paths.uniq

  redirect_paths.each do |source_path|
    # Redirect.create! source_path: source_path, target_path: article.path, temporary: false
    # puts "#{source_path} #{article.path}"
  end
end

# Site News Archive from pre- 3.0 of the site (pre Wordpress?)
file_path = File.expand_path('db/seeds/articles/site-news-archive.html', __dir__)
html_doc = File.open(file_path) { |f| Nokogiri::HTML(f) }

# And create a new Category for "Site News Archive"
category = Category.find_or_create_by! name: 'Site News Archive'

html_doc.css('.h-entry').each do |entry|
  title              = entry.css('.p-name').text
  published_at       = Time.parse(entry.css('.dt-published').text)
  content            = entry.css('.e-content').inner_html
  content            = content.delete("\n").gsub(/\s{2,}/, ' ').gsub('<p>', '').gsub('</p>', "\n\n").gsub(" \n\n ", "\n\n")

  # Save the Article
  article = Article.create!(title:              title,
                            published_at:       published_at,
                            content:            content,
                            content_format:     'html',
                            publication_status: 'published',
                            short_path:         SecureRandom.hex)

  # Add the Article to its Category
  category.articles << article
end

# New feature style Articles
# Collect the articles together

articles = [
  {
    url:          'http://www.crimethinc.com/texts/r/demands/',
    category:     'Features',
    title:        "Why We Don't Make Demands",
    published_at: Time.parse('2017-01-06T10:00 -0800'),
    image:        'https://cloudfront.crimethinc.com/assets/features/demands/images/header2560.jpg'
  },
  {
    url:          'http://www.crimethinc.com/texts/r/democracy/',
    category:     'Features',
    title:        'From Democracy to Freedom',
    published_at: Time.parse('2017-01-05T10:00 -0800'),
    image:        'https://cloudfront.crimethinc.com/assets/features/democracy/images/header2000.jpg'
  },
  {
    url:          'http://www.crimethinc.com/texts/r/kurdish/',
    category:     'Features',
    title:        'Understanding the Kurdish Resistance',
    subtitle:     'Historical Overview & Eyewitness Report',
    published_at: Time.parse('2017-01-04T10:00 -0800'),
    image:        'https://cloudfront.crimethinc.com/assets/features/kurdish/images/header2000.jpg'
  },
  {
    url:          'http://www.crimethinc.com/texts/r/next-time-it-explodes/',
    category:     'Features',
    title:        'Next Time It Explodes',
    subtitle:     'Revolt, Repression, and Backlash since the Ferguson Uprising',
    published_at: Time.parse('2017-01-03T10:00 -0800'),
    image:        'https://cloudfront.crimethinc.com/assets/features/next-time-it-explodes/images/header2000.jpg'
  },
  {
    url:          'http://www.crimethinc.com/texts/r/battle/',
    category:     'Features',
    title:        'Report Back from the Battle for Sacred Ground',
    published_at: Time.parse('2017-01-02T10:00 -0800'),
    image:        'https://cloudfront.crimethinc.com/assets/features/battle/images/header2000.jpg'
  }
]

# Loop through and create the articles
articles.each do |article_params|
  # Delete URL from params before creating Article
  article_params.delete(:url)

  # Delete Category from params before creating Article
  # And create a new Category
  category = Category.find_or_create_by! name: article_params.delete(:category)

  # article_params[:published_at]     = published_at
  article_params[:publication_status] = 'published'
  article_params[:content_format]     = 'html'
  article_params[:short_path]         = SecureRandom.hex

  # Save the Article
  article = Article.create!(article_params)

  # Find canonical Feature to Redirect to
  feature = Article.find_by(slug: "feature-#{article.slug}")
  article.content = "Redirect to Feature in feed: #{feature.path}"

  # Create Redirect
  # puts "#{article.path} #{feature.path}"
  Redirect.create source_path: article.path, target_path: feature.path, temporary: false

  # Add the Article to its Category
  category.articles << article
end

# Texts as Articles

# Text collections
inside_front               = %w[permanentvacation selling situationists veganism workethic]
rolling_thunder            = %w[antinationalist demonstrating fineart greenscared insurrection irrepressible reallyreally rncdnc rncdncdocs rnclegal shac tenyear]
harbinger                  = %w[adultery beyonddemocracy definition divided h4intro indulge infighting manifesto72 onedimensional practical secretworld ultimatum warning]
days_of_war_nights_of_love = %w[alienation alive asfuck bourgeoisie concealment contents deadhand difference domestication forward invitation joinresistance nogods nomasters product reconsideringtv seduced shoplifting system taskforce69 unabomber washing]

file_path = File.expand_path('db/seeds/articles/texts/texts', __dir__)

Dir.glob("#{file_path}/*").each do |file|
  path_pieces = file.strip.split('/')
  file_name = path_pieces.last

  next if /.DS_Store/.match?(file_name)

  doc = File.open(file) { |f| Nokogiri::HTML(f) }

  # Create the Category for Text
  file_name_slug = file_name.gsub('.php', '')

  # Set the right published_at date
  published_at_date = nil
  if %w[workethic selling situationists permanentvacation].include?(file_name_slug)
    published_at_date = 'January 1, 1996'
  elsif %w[practical].include?(file_name_slug)
    published_at_date = 'May 1, 1997'
  elsif %w[secretworld warning veganism adultery beyonddemocracy manifesto72 divided onedimensional ultimatum].include?(file_name_slug)
    published_at_date = 'September 11, 2000'
  elsif %w[h4intro indulge definition infighting].include?(file_name_slug)
    published_at_date = 'November 1, 2001'
  elsif %w[alienation alive asfuck bourgeoisie concealment contents deadhand difference domestication forward invitation joinresistance nogods nomasters product reconsideringtv seduced shoplifting system taskforce69 unabomber washing].include?(file_name_slug)
    published_at_date = 'September 11, 2000'
  else
    published_at_date = 'September 11, 1900'
  end
  published_at = Time.parse(published_at_date)

  # Set the right Category
  category_name = if inside_front.include?(file_name_slug)
                    'Inside Front'
                  elsif rolling_thunder.include?(file_name_slug)
                    'Rolling Thunder'
                  elsif harbinger.include?(file_name_slug)
                    'Harbinger'
                  elsif days_of_war_nights_of_love.include?(file_name_slug)
                    'Days of War, Nights of Love'
                  else
                    'Texts'
                  end
  category = Category.find_or_create_by name: category_name

  title                   = doc.css('h1').first.try(:text)
  subtitle                = nil
  content                 = File.read(file)
  image                   = nil

  # Save the Article
  article = Article.create!(
    title:              title || file_name_slug,
    subtitle:           subtitle,
    content:            content,
    published_at:       published_at,
    image:              image,
    publication_status: 'published',
    content_format:     'html',
    short_path:         SecureRandom.hex
  )

  # Add the Article to its Category
  category.articles << article

  # TODO
  %w[recentfeatures rollingthunder selected atoz days harbinger insidefront mostrecent pastfeatures].each do |namespace|
    [
      "/texts/#{namespace}/#{file_name_slug}",
      "/texts/#{namespace}/#{file_name_slug}/",
      "/texts/#{namespace}/#{file_name_slug}/index.html",
      "/texts/#{namespace}/#{file_name_slug}/index.php",
      "/texts/#{namespace}/#{file_name_slug}.html",
      "/texts/#{namespace}/#{file_name_slug}.php"
    ].each do |source_path|
      # Redirect.create! source_path: source_path, target_path: article.path, temporary: false
      # puts "#{source_path} #{article.path}"
    end
  end
end

#####
# First new style Article on new site

content = <<~CONTENT
  As 2017 opens, we face new challenges in an increasingly volatile world. Since last summer, we’ve been hard at work expanding our networks and updating our infrastructure to prepare for the global situation that is now unfolding. Over the next month, we’ll be announcing several ambitious new projects.
  The first of these is this website itself. We’ve assembled several new editorial groups and are in the process of overhauling the web design.
  Effective immediately, we’ll be publishing at least four new articles a week, extending our coverage to a much wider range of topics and formats. We’re not just proposing a subculture or a particular methodology of protest, but a total way of living. Accordingly, in addition to current events and analysis, we’ve established separate CrimethInc. cells to focus on technology, history, the arts, and more. Over the next two weeks, each of these groups will introduce itself here and outline its goals for this new phase of activity.
  Meanwhile, we have completely rebuilt this website. The design is now responsive, meaning that it will work equally well on your phone, tablet, laptop, and big screen.
  The complete archives of everything that has appeared online under the CrimethInc. insignia are now all in one place, [the feed](/). For now, you can [explore the feed](/read) chronologically; soon, we’ll have it organized categorically and topically as well.
  Along with overhauling this website, we're also expanding our social media presence. You can find and share CrimethInc. articles on a wide variety of networks and platforms. [Links to all of our profiles](#social) are in the website footer. You can also [join our new email list](#subscribe) to receive a forthcoming newsletter.
  We’ll be putting the finishing touches on the redesign over the next two weeks. If you notice a problem or want to offer your input, please [drop us a line](mailto:rollingthunder@crimethinc.com).
  The website is powered by an app built with [Ruby on Rails](http://rubyonrails.org).
  If you're a designer, a developer, or an adventurous explorer and want to help us build a better world, [send up a signal flare](https://github.com/crimethinc/website/issues)—we'll be waiting for you. There's still plenty of work to do (and always will be until we finally destroy empire). Front end HTML and CSS—backend Ruby and Rails—UI/UX design—copyediting—language translation. There's something for everyone.
  And we've only just begun. Stay tuned for several more surprises.
CONTENT

articles = [
  {
    category:     'Technology',
    title:        'Under No Management',
    subtitle:     'The NEW crimethinc.com',
    content:      content,
    published_at: Time.parse('2017-01-09T01:00 -0500'),
    tweet:        'Under No Management: Announcing the crimethinc.com overhaul and a new wave of projects for 2017',
    summary:      'We have completely rebuilt crimethinc.com for 2017. Here is a broad overview of the changes and a teaser the new projects we have in store for you.',
    image:        'https://cloudfront.crimethinc.com/assets/articles/2017/01/09/plant-floor.jpg',
    slug:         'under-no-management'
  }
]

# Loop through and create the articles
articles.each do |article_params|
  # Delete Category from params before creating Article
  # And create a new Category
  category = Category.find_or_create_by! name: article_params.delete(:category)

  # published
  article_params[:publication_status] = 'published'
  article_params[:short_path]         = SecureRandom.hex

  # Save the Article
  article = Article.create!(article_params)

  # Add the Article to its Category
  category.articles << article
end

##### Podcast Episode #53 post
articles = [
  {
    category:     'Podcast',
    title:        '#53: “Anti-Globalization” Walking Tour of Washington, D.C.',
    subtitle:     'Stories and Lessons from the 1999-2003 Wave of Mass Actions Against Global Capitalism',
    content:      %{Our first walking tour! Protesters descending on Washington, D.C. to [#DisruptJ20](http://www.disruptj20.org "Schedule of Events #DisruptJ20") are stepping into a long history of resistance in the belly of the beast. One of the most innovative and powerful cycles of protest in the nation’s capital was [the movement against corporate globalization](http://www.infoshop.org/Anti-Capitalist-Movements "Anti-Capitalist and Anti-Globalization Movements") in the late 1990s and early 2000s. Most tours of D.C. take you around the monuments and museums downtown, but we want to show you another side of the city—the neighborhoods and [DIY spaces](http://www.anarchistagency.com/in-the-news/the-verge-4chan-trolls-want-to-quell-anti-trump-dissent-by-shutting-down-diy-venues-and-art-spaces/) from which anarchists launched attacks on capital and where seeds were planted for a new world to take its place. Through historic sites, interviews, and a scrapbook of anti-capitalist mementos, we hope to pass on some of the lessons and inspiration that the anti-globalization movement can offer, especially as a new wave of struggle begins under Trump. [Listen to the episode here.](/podcast/53)},
    published_at: Time.parse('2017-01-08T01:00 -0500'),
    tweet:        'The Ex-Worker #53: Walking Tour of Washington, D.C. with stories from the mass actions against global capitalism.',
    summary:      'Stories and lessons from 1999-2003 Wave of Mass Actions against global capitalism.',
    image:        'https://cloudfront.crimethinc.com/assets/articles/2017/01/08/a16-march.jpg',
    slug:         'podcast-episode-53'
  }
]

# Loop through and create the articles
articles.each do |article_params|
  # Delete Category from params before creating Article
  # And create a new Category
  category = Category.find_or_create_by! name: article_params.delete(:category)

  # published
  article_params[:publication_status] = 'published'

  # Save the Article
  article = Article.create!(article_params)

  # Add the Article to its Category
  category.articles << article
end
