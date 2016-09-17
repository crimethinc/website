module ArticlesHelper

  def display_date(datetime=nil)
    unless datetime.nil?
      datetime.strftime("%Y-%m-%d")
    end
  end

end
