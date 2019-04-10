module StealSomethingFromWorkDayHelper
  def hero_background_image_css
    filename = "#{(1..9).to_a.sample}.jpg"
    url      = "https://cloudfront.crimethinc.com/assets/steal-something-from-work-day/backgrounds/#{filename}"

    "background-image: url(#{url});"
  end
end
