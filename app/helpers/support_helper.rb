module SupportHelper
  def time_until_expiration(subscription_session)
    minutes = (subscription_session.expires_at.to_i - Time.current.to_i) / 60

    if minutes.zero?
      'less than a minute'
    else
      'about ' + pluralize(minutes, 'minute')
    end
  end
end
