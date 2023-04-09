namespace :active_storage do
  desc 'Ensures all files are mirrored'
  task mirror_all: [:environment] do
    ActiveStorageMirrorSyncer.new.run
  end
end
