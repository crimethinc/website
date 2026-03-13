class ActiveStorageMirrorSyncer
  def run
    # All services in our rails configuration
    all_services = [
      ActiveStorage::Blob.service.primary,
      *ActiveStorage::Blob.service.mirrors
    ]

    # Iterate through each blob
    ActiveStorage::Blob.find_each do |blob|
      # Select services where file exists
      services = all_services.select { |file| file.exist? blob.key }

      # Skip blob if file doesn't exist anywhere
      next if services.blank?

      # Select services where file doesn't exist
      mirrors = all_services - services

      # Open the local file (if one exists) and upload to mirrors
      if services.any?(ActiveStorage::Service::DiskService)
        local_file_path = services.find do |service|
          service.is_a? ActiveStorage::Service::DiskService
        end.path_for blob.key

        File.open(local_file_path) do |local_file|
          mirrors.each do |mirror|
            mirror.upload blob.key, local_file, checksum: blob.checksum
          end
        end

        next
      end

      # If no local file exists then download a remote file and upload it to the mirrors

      services.first.open blob.key, checksum: blob.checksum do |temp_file|
        mirrors.each do |mirror|
          mirror.upload blob.key, temp_file, checksum: blob.checksum
        end
      end
    end
  end
end
