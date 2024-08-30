Rails.application.config.active_job.enqueue_after_transaction_commit = :default
Rails.application.config.active_record.validate_migration_timestamps = true
Rails.application.config.yjit = true
Rails.application.config.active_storage.web_image_content_types = %w[image/png image/jpeg image/gif image/webp]

###
# Controls whether the PostgresqlAdapter should decode dates automatically with manual queries.
#
# Example:
#   ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.select_value("select '2024-01-01'::date") #=> Date
#
# This query used to return a `String`.
#++
# Rails.application.config.active_record.postgresql_adapter_decode_dates = true
