module Admin
  class AdminController < ApplicationController
    before_action :authorize

    layout 'admin'

    def admin_title(model = nil, keys = [])
      return t(".#{action_name}_title", default: '') if model.blank?

      translation_vars = {}

      keys.each_with_object(translation_vars) do |key, hash|
        hash[key] = model.send(key)
      end

      t(".#{action_name}_title", translation_vars)
    rescue NoMethodError
      logger.error "#{controller_path}:#{action_name} has an issue with the page title"
      ''
    end

    def set_published_at
      time = params[:published_at_time]
      date = params[:published_at_date]
      tz_string = params.dig(controller_name.singularize.to_sym, :published_at_tz)

      return if date.blank? || time.blank? || tz_string.blank?

      tz = ActiveSupport::TimeZone[tz_string]
      # The `in_time_zone` is needed to account for DST. If we just did
      # `Time.parse("#{date} #{time}#{tz.formatted_offset})` we would
      # get off-by-1-hr issues if the date is far enough in the future
      # that DST toggles
      tz_offset = Time.parse("#{date} #{time}").in_time_zone(tz).strftime('%z')
      datetime  = Time.zone.parse("#{date} #{time}#{tz_offset}")
      params[controller_name.singularize.to_sym].merge!(published_at: datetime)
    end

    def set_ebook_formats
      @ebook_formats = Tool::EBOOK_FORMATS
    end
  end
end
