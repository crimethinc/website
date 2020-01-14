class CodeArchiver
  class << self
    def put_it_on_ice
      # make all the directories
      system 'mkdir', '-p', html_prefix
      system 'mkdir', '-p', md_prefix

      # generate all of the html versions of the files
      puts '**********************************************************************'
      puts 'Making html files'

      Article.published.live.in_batches.each_record do |article|
        make_article_dir article, type: :html
        make_html_article article
      end

      # generate all of the markdown versions of the files
      puts '**********************************************************************'
      puts 'Making markdown files'
      Article.published.live.in_batches.each_record do |article|
        make_article_dir article, type: :md
        make_md_article article
      end

      # print out the git commands to push this to the repo manually for now
      puts '**********************************************************************'
      puts 'here are some git commands that might work for updating the archive repo:'
      puts git_steps
    end

    private

    def make_article_dir article, type: :html
      prefix = (type == :html ? html_prefix : md_prefix)
      system 'mkdir', '-p', "#{prefix}/#{article_dir(article)}"
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

    def git_steps
      <<~HEREDOC
        cd website-content/ && \\\n
        git init && \\\n
        git remote add origin git@github.com:crimethinc/website-content.git && \\\n
        git fetch origin && \\\n
        git checkout master && \\\n
        git stash save && \\\n
        git checkout -b $(date +"%m-%d-%y") && \\\n
        git pull --rebase origin master && \\\n
        git stash pop && \\\n
        git add . && \\\n
        git commit -am "update: $(date +"%m-%d-%y")" && \\\n
        git push --set-upstream origin $(date +"%m-%d-%y") \\\n
      HEREDOC
    end

    def html_prefix
      'website-content/html/articles'
    end

    def md_prefix
      'website-content/markdown/articles'
    end
  end
end
