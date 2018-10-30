require 'rails_helper'

describe 'Tools Pages' do
  before do
    create(:status, :published)
    create(:status, :draft)
  end

  it 'Renders published logos calling /logos' do
    FactoryBot.create(:logo,
                      title: 'published',
                      status_id: Status.find_by(name: 'published').id)

    FactoryBot.create(:logo,
                      title: 'draft',
                      status_id: Status.find_by(name: 'draft').id)

    visit '/logos'

    expect(page).to have_content 'published'
    expect(page).not_to have_content 'draft'
  end

  it 'Renders published stickers calling /stickers' do
    FactoryBot.create(:poster,
                      :sticker,
                      title: 'published',
                      published_at: 1.day.ago,
                      status_id: Status.find_by(name: 'published').id)

    FactoryBot.create(:poster,
                      :sticker,
                      title: 'not live',
                      published_at: 1.day.from_now,
                      status_id: Status.find_by(name: 'published').id)

    FactoryBot.create(:poster,
                      :sticker,
                      title: 'draft',
                      status_id: Status.find_by(name: 'draft').id)

    visit '/stickers'

    expect(page).to have_content 'published'
    expect(page).not_to have_content 'draft'
    expect(page).not_to have_content 'not live'
  end

  it 'Renders published zines calling /zines' do
    FactoryBot.create(:book,
                      :zine,
                      title: 'published',
                      published_at: 1.day.ago,
                      status_id: Status.find_by(name: 'published').id)

    FactoryBot.create(:book,
                      :zine,
                      title: 'not live',
                      published_at: 1.day.from_now,
                      status_id: Status.find_by(name: 'published').id)

    FactoryBot.create(:book,
                      :zine,
                      title: 'draft',
                      status_id: Status.find_by(name: 'draft').id)

    visit '/zines'

    expect(page).to have_content 'published'
    expect(page).not_to have_content 'draft'
    expect(page).not_to have_content 'not live'
  end

  it 'Renders published posters calling /posters' do
    FactoryBot.create(:poster,
                      title: 'published',
                      published_at: 1.day.ago,
                      status_id: Status.find_by(name: 'published').id)

    FactoryBot.create(:poster,
                      title: 'not live',
                      published_at: 1.day.from_now,
                      status_id: Status.find_by(name: 'published').id)

    FactoryBot.create(:poster,
                      title: 'draft',
                      status_id: Status.find_by(name: 'draft').id)

    visit '/posters'

    expect(page).to have_content 'published'
    expect(page).not_to have_content 'draft'
    expect(page).not_to have_content 'not live'
  end

  it 'Renders published videos calling /videos' do
    FactoryBot.create(:video,
                      title: 'published',
                      status_id: Status.find_by(name: 'published').id)

    FactoryBot.create(:video,
                      title: 'draft',
                      status_id: Status.find_by(name: 'draft').id)

    visit '/videos'

    expect(page).to have_content 'published'
    expect(page).not_to have_content 'draft'
  end
end
