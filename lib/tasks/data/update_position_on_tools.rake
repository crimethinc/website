namespace :data do
  desc 'Update position on tools'
  task :update_position_on_tools => :environment do |_, args|
    puts 'Updating zines position'
    Zine.all.update_all(position: 10)
    Zine.where(buy_url: nil).or(Zine.where(buy_url: "")).update_all(position: 0)

    puts 'Updating posters position'
    Poster.all.update_all(position: 10)
    Poster.where(buy_url: nil).or(Poster.where(buy_url: "")).update_all(position: 0)

    puts 'Updating stickers position'
    Sticker.all.update_all(position: 10)
    Sticker.where(buy_url: nil).or(Sticker.where(buy_url: "")).update_all(position: 0)

    puts 'Updating logos position'
    Logo.all.update_all(position: 0)
  end
end
