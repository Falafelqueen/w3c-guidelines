module PagesHelper

  def style_day(day)
    day_array = day.split("_")
    day_array.first.capitalize
    "monda"
  end
end
