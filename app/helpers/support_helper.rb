module SupportHelper
  def minutes_until_expiration support_session
    (support_session.expires_at.to_i - Time.current.to_i) / 60
  end
end
