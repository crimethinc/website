require 'rails_helper'

feature "Tools Pages" do

  background do
    create(:status, :published)
    create(:status, :draft)
  end
  scenario "Renders published logos calling tools/logos" do
    FactoryGirl.create(:logo, 
                        title: "published", 
                        status_id: Status.find_by(name: "published").id)

    FactoryGirl.create(:logo,
                        title: "draft", 
                        status_id: Status.find_by(name: "draft").id)

    visit '/tools/logos'

    expect(page).to have_content 'published'
    expect(page).to_not have_content 'draft'
  end

  scenario "Renders published stickers calling tools/sticker" do
    FactoryGirl.create(:poster,
                        :sticker,
                        title: "published", 
                        status_id: Status.find_by(name: "published").id)

    FactoryGirl.create(:poster,
                        :sticker, 
                        title: "draft", 
                        status_id: Status.find_by(name: "draft").id)

    visit '/tools/stickers'

    expect(page).to have_content 'published'
    expect(page).to_not have_content 'draft'
  end

  scenario "Renders published zines calling tools/zines" do
    FactoryGirl.create(:book,
                        :zine, 
                        title: "published", 
                        status_id: Status.find_by(name: "published").id)

    FactoryGirl.create(:book,
                        :zine, 
                        title: "draft", 
                        status_id: Status.find_by(name: "draft").id)

    visit '/tools/zines'

    expect(page).to have_content 'published'
    expect(page).to_not have_content 'draft'
  end

  scenario "Renders published posters calling tools/posters" do
    FactoryGirl.create(:poster, 
                       title: "published", 
                       status_id: Status.find_by(name: "published").id)

    FactoryGirl.create(:poster, 
                        title: "draft", 
                        status_id: Status.find_by(name: "draft").id)

    visit '/tools/posters'

    expect(page).to have_content 'published'
    expect(page).to_not have_content 'draft'
  end


  scenario "Renders published videos calling tools/videos" do
    FactoryGirl.create(:video, 
                       title: "published", 
                       status_id: Status.find_by(name: "published").id)

    FactoryGirl.create(:video, 
                        title: "draft", 
                        status_id: Status.find_by(name: "draft").id)

    visit '/tools/videos'

    expect(page).to have_content 'published'
    expect(page).to_not have_content 'draft'
  end
end