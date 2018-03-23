require "nokogiri"

filepath = File.expand_path("../db/seeds/redirects/redirects.html", __FILE__)
html_doc  = File.open(filepath) { |form| Nokogiri::HTML(form) }

html_doc.css("#main_table tbody tr").each do |table_row|
  unless table_row.attribute("id").value == "nourl_found"
    source_path = table_row.css(".keyword a").text
    target_path = table_row.css(".url a").first.attribute("href")

    Redirect.create! source_path: source_path, target_path: target_path, temporary: false

    # TODO use later to give old features a published_at timestamp
    # published_at = Time.parse(table_row.css(".timestamp").text)
    # puts "#{target_path} : #{source_path} : #{published_at}"
  end
end
