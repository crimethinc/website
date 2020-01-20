class CodeArchiver
  class << self
    def put_it_on_ice # rubocop:disable Metrics/MethodLength
      # make all the directories
      system 'mkdir', '-p', html_prefix
      system 'mkdir', '-p', md_prefix
      system 'mkdir', '-p', html_prefix(type: 'pages')
      system 'mkdir', '-p', md_prefix(type: 'pages')

      puts '**********************************************************************'
      puts 'Making html article files'
      Article.published.live.in_batches.each_record do |article|
        make_article_dir article, type: :html
        make_html_article article
      end

      puts '**********************************************************************'
      puts 'Making markdown article files'
      Article.published.live.in_batches.each_record do |article|
        make_article_dir article, type: :md
        make_md_article article
      end

      puts '**********************************************************************'
      puts 'Making html page files'
      Page.where(slug: %i[about faq]).each do |page|
        make_page_dir page, type: :html
        make_html_page page
      end

      puts '**********************************************************************'
      puts 'Making markdown page files'
      Page.where(slug: %i[about faq]).each do |page|
        make_page_dir page, type: :md
        make_md_page page
      end

      puts '**********************************************************************'
      puts 'here are some git commands that might work for updating the archive repo:'
      puts git_steps
    end

    private

    def make_article_dir article, type: :html
      system 'mkdir', '-p', "#{html_prefix}/#{article_dir(article)}" if type == :html
      system 'mkdir', '-p', "#{md_prefix}/#{article_dir(article)}" if type == :md
    end

    def make_page_dir page, type: :html
      system 'mkdir', '-p', "#{html_prefix(type: 'pages')}/#{page.slug}}" if type == :html
      system 'mkdir', '-p', "#{md_prefix(type: 'pages')}/#{page.slug}" if type == :md
    end

    def make_html_article article
      File.open("#{html_prefix}/#{article_dir(article)}/#{article.slug}.html", 'w') do |file|
        file.puts "<h1>#{article.title}</h1>"
        file.puts "<h2>#{article.subtitle}</h2>" unless article.subtitle.blank?
        file.puts to_html article
      end
    end

    def make_md_article article
      File.open("#{md_prefix}/#{article_dir(article)}/#{article.slug}.md", 'w') do |file|
        file.puts "# #{article.title}"
        file.puts "## #{article.subtitle}" unless article.subtitle.blank?
        file.puts to_markdown article
      end
    end

    def make_html_page page
      File.open("#{html_prefix(type: 'pages')}/#{page.slug}.html", 'w') do |file|
        file.puts "<h1>#{page.title}</h1>"
        file.puts "<h2>#{page.subtitle}</h2>" unless page.subtitle.blank?
        file.puts to_html page
      end
    end

    def make_md_page page
      File.open("#{md_prefix(type: 'pages')}/#{page.slug}.md", 'w') do |file|
        file.puts "# #{page.title}"
        file.puts "## #{page.subtitle}" unless page.subtitle.blank?
        file.puts to_markdown page
      end
    end

    def article_dir article
      "#{article.year}/#{article.month}/#{article.day}/"
    end

    def to_html article
      Kramdown::Document.new(
        MarkdownMedia.parse(article.content, include_media: false),
        input:                     :kramdown,
        remove_block_html_tags:    false,
        transliterated_header_ids: true
      ).to_html
    end

    def to_markdown article
      Kramdown::Document.new(
        MarkdownMedia.parse(article.content, include_media: false),
        input:                     :kramdown,
        remove_block_html_tags:    false,
        transliterated_header_ids: true
      ).to_kramdown
    end

    def to_pdf article
      Kramdown::Document.new(
        MarkdownMedia.parse(article.content, include_media: true),
        input:                     :kramdown,
        remove_block_html_tags:    false,
        transliterated_header_ids: true
      ).to_latex
    end

    def git_steps
      <<~HEREDOC
        cd website-content/ && \\\n
        git init && \\\n
        git remote add origin git@github.com:crimethinc/website-content.git && \\\n
        git fetch origin && \\\n
        git checkout -b $(date +"%m-%d-%y") && \\\n
        git add . && \\\n
        git commit -am "update: $(date +"%m-%d-%y")" && \\\n
        git pull --rebase origin master && \\\n
        git push --set-upstream origin $(date +"%m-%d-%y") \\\n
      HEREDOC
    end

    def html_prefix type: 'articles'
      "website-content/html/#{type}"
    end

    def md_prefix type: 'articles'
      "website-content/markdown/#{type}"
    end
  end
end
