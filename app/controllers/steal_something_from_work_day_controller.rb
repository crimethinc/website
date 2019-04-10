class StealSomethingFromWorkDayController < ApplicationController
  layout 'steal_something_from_work_day'

  # TODO
  # STEAL_SOMETHING_FROM_WORK_DAY_LOCALES = %w[english].freeze

  def show
    # TODO

    I18n.locale = 'english'
    # @title = I18n.t('page_titles.about.steal_something_from_work_day')
    @title = I18n.t('layouts.steal_something_from_work_day.language_direction')
    puts "----------------------------------------------------------------------"
    puts "#@title"
    
    @sections = [
      'Introduction',
      'FAQ',
      'Outreach Materials',
      'Interviews',
      'Analysis',
      'Narratives',
      'Testimonials',
      'Further Reading',
      'Selected Coverage',
      'Internationally'
    ]

    # TODO
    # if STEAL_SOMETHING_FROM_WORK_DAY_LOCALES.include?(@locale)
    #   I18n.locale = @locale
    # else
    #   I18n.locale = @locale = I18n.default_locale
    #   redirect_to [:steal_something_from_work_day]
    # end
  end
end
