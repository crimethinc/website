module SupportHelper

  def time_until_expiration(subscription_session)
    minutes = (subscription_session.expires_at.to_i - Time.current.to_i) / 60

    if minutes == 0
      "less than a minute"
    else
      "#{minutes} minutes"
    end
  end

  def subscription_amounts
    select_options = [
      ['Amount', nil]
    ]

    %w[
      1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 30 35 40
      45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125 130 135 140 145
      150 200 250 300 350 400 450 500 550 600 650 700 750 800 850 900 950 1000
    ].each do |i|
       select_options << ["$#{i}", i.to_i]
    end

    select_options
  end
end
