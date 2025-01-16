class CodeArchiver
  def run
    # make all the directories
    system 'mkdir', '-p', articles_prefix
    system 'mkdir', '-p', pages_prefix

    puts '*' * 80
    puts 'Making html article files'
    Article.published.live.in_batches.each_record do |article|
      make_article_dir article
      make_html_article article
    end

    puts '*' * 80
    puts 'Making markdown article files'
    Article.published.live.in_batches.each_record do |article|
      make_article_dir article
      make_md_article article
    end

    puts '*' * 80
    puts 'Making html page files'
    Page.where(slug: %i[about faq]).find_each do |page|
      make_page_dir page
      make_html_page page
    end

    puts '*' * 80
    puts 'Making markdown page files'
    Page.where(slug: %i[about faq]).find_each do |page|
      make_page_dir page
      make_md_page page
    end

    puts '*' * 80
    if ENV.fetch('STATIC_EXPORT_IMAGES') { nil }.present?
      puts 'downloading local copies of article images. this will take a while...'
      download_article_images
    else
      puts 'SKIPPING IMAGE DOWNLOADS: use env variable STATIC_EXPORT_IMAGES=1 to include images'
    end

    puts '*' * 80
    puts 'here are some git commands that might work for updating the archive repo:'
    puts git_steps
  end

  private

  def make_article_dir article
    system 'mkdir', '-p', "#{articles_prefix}/#{article_dir(article)}"
  end

  def make_page_dir page
    system 'mkdir', '-p', "#{pages_prefix}/#{page.slug}}"
  end

  def make_html_article article
    File.open("#{articles_prefix}/#{article_dir(article)}/#{article.slug}.html", 'w') do |file|
      file.puts "<h1>#{article.title}</h1>"
      file.puts "<h2>#{article.subtitle}</h2>" if article.subtitle.present?
      file.puts to_html article
    end
  end

  def make_md_article article
    File.open("#{articles_prefix}/#{article_dir(article)}/#{article.slug}.md", 'w') do |file|
      file.puts "# #{article.title}"
      file.puts "## #{article.subtitle}" if article.subtitle.present?
      file.puts to_markdown article
    end
  end

  def make_html_page page
    File.open("#{pages_prefix}/#{page.slug}.html", 'w') do |file|
      file.puts "<h1>#{page.title}</h1>"
      file.puts "<h2>#{page.subtitle}</h2>" if page.subtitle.present?
      file.puts to_html page
    end
  end

  def make_md_page page
    File.open("#{pages_prefix}/#{page.slug}.md", 'w') do |file|
      file.puts "# #{page.title}"
      file.puts "## #{page.subtitle}" if page.subtitle.present?
      file.puts to_markdown page
    end
  end

  def article_dir article
    "#{article.year}/#{article.month}/#{article.day}/"
  end

  def to_html article
    Kramdown::Document.new(
      MarkdownMedia.parse(article.content, include_media: true),
      input:                     :kramdown,
      remove_block_html_tags:    false,
      transliterated_header_ids: true
    ).to_html
  end

  def to_markdown article
    Kramdown::Document.new(
      MarkdownMedia.parse(article.content, include_media: true),
      input:                     :kramdown,
      remove_block_html_tags:    false,
      transliterated_header_ids: true
    ).to_kramdown
  end

  def git_steps
    <<~HEREDOC
      cd website-content/ && \\
      git init && \\
      git remote add origin git@github.com:crimethinc/website-content.git && \\
      git fetch origin && \\
      git checkout -b $(date +"%m-%d-%y") && \\
      git add . && \\
      git commit -am "update: $(date +"%m-%d-%y")" && \\
      git pull --rebase origin master && \\
      git push --set-upstream origin $(date +"%m-%d-%y") \\
    HEREDOC
  end

  def articles_prefix
    'website-content/articles'
  end

  def pages_prefix
    'website-content/pages'
  end

  def download_article_images
    files = `grep -hrioE '"http[s]?:\/\/cloudfront\.crimethinc\.com.*"' website-content/articles/ | sort | uniq`
    count = `grep -hrioE '"http[s]?:\/\/cloudfront\.crimethinc\.com.*"' website-content/articles/ | sort | uniq| wc -l`
            .to_i

    files = files.tr('\"', '').split("\n")

    files.each_with_index do |url, index|
      puts "#{count - index} files left"
      uri = URI.parse(url)
      next unless uri.path.start_with?('/assets/articles/')

      filepath = uri.path.split('/').drop(2).join('/')
      `curl -s --create-dirs -o "website-content/#{filepath}" "#{url}"`
    rescue URI::InvalidURIError
      puts "#{url} is not a valid asset URL"
    end

    :done
  end
end
