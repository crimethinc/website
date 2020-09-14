namespace :data do
  desc 'Update position on tools'
  task :update_position_on_tools do
    puts 'Updating zines position'
    Zine.where.not(buy_url: [nil, '']).update_all(position: 1)

    puts 'Updating posters position'
    Poster.where.not(buy_url: [nil, '']).update_all(position: 1)

    puts 'Updating stickers position'
    Sticker.where.not(buy_url: [nil, '']).update_all(position: 1)
  end
end
