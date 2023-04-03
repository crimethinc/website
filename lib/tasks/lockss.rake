namespace :static do
  desc 'Create a data archive for the Github code vault'
  task export: %i[db:import] do
    CodeArchiver.new.run
  end
end
