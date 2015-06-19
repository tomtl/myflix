module ApplicationHelper
  def options_for_video_reviews(selected = nil)
    options_for_select(rating_values_list, selected)
  end

  def options_for_categories
    options_for_select(Category.all.map{ |category| [category.name, category.id] })
  end

  def rating_values_list
    [5,4,3,2,1].map { |number| [pluralize(number, "Star"), number] }
  end
end
