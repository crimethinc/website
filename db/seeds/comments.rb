require 'nokogiri'
require 'csv'

# Wordpress posts
filepath = File.expand_path('db/seeds/articles/posts/')

unless File.directory?(filepath)
  puts 'got at the root directory of the project and run `ruby db/seeds/comments.rb`'
end

csv = CSV.open('./comments.csv', 'w')
csv << [:article_id, :article_url, :article_title, :comment_id, :comment_author, :comment_author_email, :comment_author_url, :comment_date_gmt, :comment_content, :keep]

Dir.glob("#{filepath}/*").each do |f|
  filename = f.strip.split('/').last

  unless filename =~ /.DS_Store/
    doc = File.open(f) { |f| Nokogiri::XML(f) }

    post_id = doc.css('wp_post_id').text
    post_url = doc.css('link').text
    post_title = doc.css('title').text

    comments = doc.css('wp_comment')
    unless comments.empty?
      comments.each do |comment|
        comment_id = comment.css('wp_comment_id').text
        comment_author = comment.css('wp_comment_author').text
        comment_author_email = comment.css('wp_comment_author_email').text
        comment_author_url = comment.css('wp_comment_author_url').text
        comment_date_gmt = comment.css('wp_comment_date_gmt').text
        comment_content = comment.css('wp_comment_content').text
        csv << [post_id, post_url, post_title, comment_id, comment_author, comment_author_email, comment_author_url, comment_date_gmt, comment_content, '']
      end
    end
  end
end

csv.close()
