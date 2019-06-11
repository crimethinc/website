require 'rails_helper'

describe 'Navigating to special 1-off pages' do
  before { %i[about start faq contact].each { |slug| create_page_with slug } }

  shared_examples 'loads correct page' do |slug, content|
    let(:expected_content) { content }
    let(:slug) { slug }

    it 'works' do
      visit "/#{slug}"
      expect(page).to have_current_path("/#{slug}")
      expect(page).to have_content expected_content
    end
  end

  context 'with path /about' do
    include_examples 'loads correct page', :about, 'What Is Crimethink?'
  end

  context 'with path /start' do
    include_examples 'loads correct page', :start, 'If This Is Your First Time Here'
  end

  context 'with path /contact' do
    include_examples 'loads correct page', :contact, 'The best we can offer here is a partial listing—'
  end

  # The /faq page is different from the other `Pages` because it
  # appears to be a redirect to `/begin`, which is an actual article
  context 'with path /faq' do
    it 'works' do
      visit '/faq'
      expect(page).to have_current_path('/2016/09/28/feature-the-secret-is-to-be' \
                                        'gin-getting-started-further-resources-f' \
                                        'requently-asked-questions')
      expect(page).to have_content 'Frequently Asked Questions about Anarchism'
    end
  end

  context 'with a non-existing page path' do
    it 'redirect to thee home page' do
      visit '/blahblahblah'
      expect(page).to have_current_path '/'
    end
  end

  def create_page_with(slug)
    if slug == :faq
      Redirect.create!(
        source_path: '/faq',
        target_path: '/2016/09/28/feature-the-secret-is-to-begin-getting' \
                     '-started-further-resources-frequently-asked-questions#faq'
      )

      path = Rails.root.join('db', 'seeds', 'articles', 'features', 'begin', 'index.html')
      slug = 'feature-the-secret-is-to-begin-getting-started-further-resources-frequently-asked-questions'

      article = Article.create!(
        title:              'a title',
        subtitle:           '',
        content:            File.read(path),
        published_at:       Time.zone.parse('2016-09-28 08:11:00 -0700'),
        image:              'foo',
        publication_status: 'published',
        content_format:     'html',
        short_path:         SecureRandom.hex
      )
      article.slug = slug
      article.save!
    end

    create(:page,
           title: "title for #{slug}",
           content: "content for #{slug}",
           publication_status: 'published',
           published_at: Time.zone.parse('2017-01-01'),
           slug: slug.to_s,
           image: 'https://cloudfront.crimethinc.com/assets/pages/start/start-header.jpg')
  end
end
