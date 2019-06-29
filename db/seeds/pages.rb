content = <<~CONTENT
  - [Who we are and what we do](/about)
  - [A basic introduction to anarchist values](/tce)
  - [Frequently asked questions about anarchism](/begin#fa)
  - [More introductory resources](/begin#fr)
  - [What you can do](/begin#gs)
  - [For more coverage of anarchist activity in North America](https://itsgoingdown.org)
CONTENT

Page.create!(
  title:              'If This Is Your First Time Here&hellip;',
  content:            content,
  publication_status: 'published',
  published_at:       Time.parse('2017-01-01'),
  slug:               'start',
  image:              'https://cloudfront.crimethinc.com/assets/pages/start/start-header.jpg'
)

Page.find_or_create_by!(slug: 'contact') do |page|
  page.title = 'Contact'
  page.content = 'a placeholder /contact page'
  page.publication_status = 'published'
  page.published_at = Time.zone.parse('2017-01-01')
  page.image = ''
end

Page.find_or_create_by!(slug: 'about') do |page|
  page.title = 'About'
  page.content = 'a placeholder /about page'
  page.publication_status = 'published'
  page.published_at = Time.zone.parse('2017-01-01')
  page.image = ''
end

Page.find_or_create_by!(slug: 'faq') do |page|
  page.title = 'FAQ'
  page.content = 'a placeholder /FAQ page'
  page.publication_status = 'published'
  page.published_at = Time.zone.parse('2017-01-01')
  page.image = ''
end
# FAQ requires a redirect to the `begin` feature
slug = 'feature-the-secret-is-to-begin-getting-started-further-resources-frequently-asked-questions'
Redirect.find_or_create_by!(source_path: '/faq') do |redirect|
  redirect.target_path = "/2016/09/28/#{slug}#faq"
end
