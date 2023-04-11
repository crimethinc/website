ActiveStorage::Engine.config.active_storage.content_types_to_serve_as_binary.delete 'image/svg+xml'

# TODO: replace above line with this line below
#       ActiveStorage::Engine is a private API
# Rails.application.config.active_storage.content_types_to_serve_as_binary -= ['image/svg+xml']

Rails.application.config.active_storage.resolve_model_to_route = :rails_storage_proxy
