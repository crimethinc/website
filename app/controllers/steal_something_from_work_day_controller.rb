class StealSomethingFromWorkDayController < ApplicationController
  layout 'steal_something_from_work_day'

  STEAL_SOMETHING_FROM_WORK_DAY_LOCALES = %i[cz de en es fr].freeze

  def show
    unless STEAL_SOMETHING_FROM_WORK_DAY_LOCALES.include? I18n.locale
      I18n.locale = I18n.default_locale
      redirect_to [:steal_something_from_work_day]
    end

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
  end
end
