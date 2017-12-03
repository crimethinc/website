require "rails_helper"

feature "Tools Pages" do
  background do
    create(:status, :published)
    create(:status, :draft)
  end

  scenario "Renders published logos calling /logos" do
    FactoryBot.create(:logo,
                      title: "published",
                      status_id: Status.find_by(name: "published").id)

    FactoryBot.create(:logo,
                      title: "draft",
                      status_id: Status.find_by(name: "draft").id)

    visit "/logos"

    expect(page).to have_content "published"
    expect(page).to_not have_content "draft"
  end

  scenario "Renders published stickers calling /stickers" do
    FactoryBot.create(:poster,
                      :sticker,
                      title: "published",
                      status_id: Status.find_by(name: "published").id)

    FactoryBot.create(:poster,
                      :sticker,
                      title: "draft",
                      status_id: Status.find_by(name: "draft").id)

    visit "/stickers"

    expect(page).to have_content "published"
    expect(page).to_not have_content "draft"
  end

  scenario "Renders published zines calling /zines" do
    FactoryBot.create(:book,
                      :zine,
                      title: "published",
                      status_id: Status.find_by(name: "published").id)

    FactoryBot.create(:book,
                      :zine,
                      title: "draft",
                      status_id: Status.find_by(name: "draft").id)

    visit "/zines"

    expect(page).to have_content "published"
    expect(page).to_not have_content "draft"
  end

  scenario "Renders published posters calling /posters" do
    FactoryBot.create(:poster,
                       title: "published",
                       status_id: Status.find_by(name: "published").id)

    FactoryBot.create(:poster,
                      title: "draft",
                      status_id: Status.find_by(name: "draft").id)

    visit "/posters"

    expect(page).to have_content "published"
    expect(page).to_not have_content "draft"
  end


  scenario "Renders published videos calling /videos" do
    FactoryBot.create(:video,
                       title: "published",
                       status_id: Status.find_by(name: "published").id)

    FactoryBot.create(:video,
                      title: "draft",
                      status_id: Status.find_by(name: "draft").id)

    visit "/videos"

    expect(page).to have_content "published"
    expect(page).to_not have_content "draft"
  end
end