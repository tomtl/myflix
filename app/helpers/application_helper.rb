module ApplicationHelper
  def options_for_video_reviews(selected=nil)
    options_for_select([5,4,3,2,1].map { |number| [pluralize(number, "Star")] }, selected)
  end
  
  def rating_values_list
    [5,4,3,2,1].map { |number| [pluralize(number, "Star")] }
  end
end
