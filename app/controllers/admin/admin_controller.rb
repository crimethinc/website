module Admin
  class AdminController < ApplicationController
    before_action :authorize
    before_action :set_current_theme

    layout 'admin'

    def admin_title model = nil, keys = []
      # controller_name is 'admin', controller_path is 'admin/articles'
      #    we need 'Article' for the title from models locale YAML
      controller_name_space  = :admin
      nested_controller_name = controller_path.split('/').last

      if model.blank?
        subtitle = t :other, scope: [:activerecord, :models, nested_controller_name.singularize]
        return PageTitle.new(['Admin', subtitle]).content
      end

      return '' unless keys.all? { |key| model.respond_to? key }

      translation_vars = keys.index_with { |key| model.send(key) }

      lookup_path = [
        :views,
        controller_name_space,
        nested_controller_name,
        action_name,
        :title
      ].join('.')

      PageTitle.new(['Admin', t(lookup_path, **translation_vars)]).content
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
