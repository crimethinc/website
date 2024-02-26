module Admin
  class AdminController < ApplicationController
    before_action :authorize
    before_action :set_current_theme

    layout 'admin'

    def admin_title model = nil, keys = []
      return PageTitle.new(['Admin', t(".#{action_name}_title")]).content if model.blank?
      return '' unless keys.all? { |key| model.respond_to? key }

      translation_vars = keys.index_with { |key| model.send(key) }

      PageTitle.new(['Admin', t(".#{action_name}_title", **translation_vars)]).content
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

      params[controller_name.singularize.to_sym][:published_at] = datetime
    end

    def set_current_theme
      Current.theme = 2017
    end
  end
end
