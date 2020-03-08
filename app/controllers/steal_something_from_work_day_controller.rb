class StealSomethingFromWorkDayController < ApplicationController
  layout 'steal_something_from_work_day'

  STEAL_SOMETHING_FROM_WORK_DAY_LOCALES = {
    cs: 'Czech',
    de: 'Deutsche',
    en: 'English',
    fr: 'Français'
  }.freeze

  def show
    unless STEAL_SOMETHING_FROM_WORK_DAY_LOCALES.key? I18n.locale
      I18n.locale = I18n.default_locale
      redirect_to [:steal_something_from_work_day]
    end

    # Remove current locale from language switcher in the view
    @locales = STEAL_SOMETHING_FROM_WORK_DAY_LOCALES.dup
    @locales.delete I18n.locale

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
