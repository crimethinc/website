require 'rails_helper'

describe 'Tools Pages' do
  it 'Renders published logos calling /logos' do
    FactoryBot.create(:logo,
                      title: 'published',
                      published_at: 1.day.ago,
                      publication_status: 'published')

    FactoryBot.create(:logo,
                      title: 'not live',
                      published_at: 1.day.from_now,
                      publication_status: 'published')

    FactoryBot.create(:logo,
                      title: 'draft',
                      publication_status: 'draft')

    visit '/logos'

    expect(page).to have_content 'published'
    expect(page).not_to have_content 'draft'
    expect(page).not_to have_content 'not live'
  end

  it 'Renders published stickers calling /stickers' do
    FactoryBot.create(:sticker,
                      title: 'published',
                      published_at: 1.day.ago,
                      publication_status: 'published')

    FactoryBot.create(:sticker,
                      title: 'not live',
                      published_at: 1.day.from_now,
                      publication_status: 'published')

    FactoryBot.create(:sticker,
                      title: 'draft',
                      publication_status: 'draft')

    visit '/stickers'

    expect(page).to have_content 'published'
    expect(page).not_to have_content 'draft'
    expect(page).not_to have_content 'not live'
  end

  it 'Renders published zines calling /zines' do
    FactoryBot.create(:zine,
                      title: 'published',
                      published_at: 1.day.ago,
                      publication_status: 'published')

    FactoryBot.create(:zine,
                      title: 'not live',
                      published_at: 1.day.from_now,
                      publication_status: 'published')

    FactoryBot.create(:zine,
                      title: 'draft',
                      publication_status: 'draft')

    visit '/zines'

    expect(page).to have_content 'published'
    expect(page).not_to have_content 'draft'
    expect(page).not_to have_content 'not live'
  end

  it 'Renders published posters calling /posters' do
    FactoryBot.create(:poster,
                      title: 'published',
                      published_at: 1.day.ago,
                      publication_status: 'published')

    FactoryBot.create(:poster,
                      title: 'not live',
                      published_at: 1.day.from_now,
                      publication_status: 'published')

    FactoryBot.create(:poster,
                      title: 'draft',
                      publication_status: 'draft')

    visit '/posters'

    expect(page).to have_content 'published'
    expect(page).not_to have_content 'draft'
    expect(page).not_to have_content 'not live'
  end

  it 'Renders published videos calling /videos' do
    FactoryBot.create(:video,
                      title: 'published',
                      published_at: 1.day.ago,
                      publication_status: 'published')

    FactoryBot.create(:video,
                      title: 'not live',
                      published_at: 1.day.from_now,
                      publication_status: 'published')

    FactoryBot.create(:video,
                      title: 'draft',
                      publication_status: 'draft')

    visit '/videos'

    expect(page).to have_content 'published'
    expect(page).not_to have_content 'not live'
    expect(page).not_to have_content 'draft'
  end
end
