Rails.application.config.active_job.enqueue_after_transaction_commit = :default

###
# Adds image/webp to the list of content types Active Storage considers as an image
# Prevents automatic conversion to a fallback PNG, and assumes clients support WebP, as they support gif, jpeg, and png.
# This is possible due to broad browser support for WebP, but older browsers and email clients may still not support
# WebP. Requires imagemagick/libvips built with WebP support.
#++
# Rails.application.config.active_storage.web_image_content_types = %w[image/png image/jpeg image/gif image/webp]

###
# Enable validation of migration timestamps. When set, an ActiveRecord::InvalidMigrationTimestampError
# will be raised if the timestamp prefix for a migration is more than a day ahead of the timestamp
# associated with the current time. This is done to prevent forward-dating of migration files, which can
# impact migration generation and other migration commands.
#
# Applications with existing timestamped migrations that do not adhere to the
# expected format can disable validation by setting this config to `false`.
#++
# Rails.application.config.active_record.validate_migration_timestamps = true

###
# Controls whether the PostgresqlAdapter should decode dates automatically with manual queries.
#
# Example:
#   ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.select_value("select '2024-01-01'::date") #=> Date
#
# This query used to return a `String`.
#++
# Rails.application.config.active_record.postgresql_adapter_decode_dates = true
