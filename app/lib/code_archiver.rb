class CodeArchiver
  class << self
    def put_it_on_ice
      # make all the directories
      system 'mkdir', '-p', html_prefix
      system 'mkdir', '-p', md_prefix
      system 'mkdir', '-p', pdf_prefix

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

      # TODO: this will generate tex files, but those then need to be
      # converted into PDF. I messed around with that manually and
      # couldn't get image loading and unicode looked bad, so not worth
      # it unless i figure those things out

      # puts '**********************************************************************'
      # puts 'Making pdf article files'
      # Article.published.live.in_batches.each_record do |article|
      #   make_article_dir article, type: :pdf
      #   make_pdf_article article
      # end

      puts '**********************************************************************'
      puts 'here are some git commands that might work for updating the archive repo:'
      puts git_steps
    end

    private

    def make_article_dir article, type: :html
      system 'mkdir', '-p', "#{html_prefix}/#{article_dir(article)}" if type == :html
      system 'mkdir', '-p', "#{md_prefix}/#{article_dir(article)}" if type == :md
      system 'mkdir', '-p', "#{pdf_prefix}/#{article_dir(article)}" if type == :pdf
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

    def make_pdf_article article
      File.open("#{pdf_prefix}/#{article_dir(article)}/#{article.slug}.tex", 'w') do |file|
        file.puts to_pdf article
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

    def html_prefix
      'website-content/html/articles'
    end

    def md_prefix
      'website-content/markdown/articles'
    end

    def pdf_prefix
      'website-content/pdf/articles'
    end
  end
end
